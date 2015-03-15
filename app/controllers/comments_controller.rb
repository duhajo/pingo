class CommentsController < ApplicationController

  def edit
    @comment = Comment.find(params[:id])
  end
  
  def reply
    @job = Job.find(params[:job_id])
    @parent_comment = Comment.find(params[:comment_id])
    @parent_id = @parent_comment.id
    @comment = Comment.new
    
    respond_to do |format|
       format.js
    end
  end

  def reply_to_activity
    @job = Job.find(params[:job_id])
    @activity = PublicActivity::Activity.find(params[:a_id])
    @parent_id = @activity.id
    @type = "activity"
    @comment = Comment.new

    respond_to do |format|
      format.js { render :template => 'comments/reply'}
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @job = Job.find(params[:job_id])
    if(params[:comment][:type] == "activity" && params[:comment][:parent_id])
      @comment = Comment.comment_for_activity(@job, current_user.id, params[:comment][:body], params[:comment][:type], params[:comment][:parent_id])
      respond_to do |format|
        if @comment.save
          format.html {
            redirect_to @job
            gflash :success => "Kommentar auf die Datei erfolgreich erstellt!"
          }
        end
      end
    else
      @comment = Comment.build_from(@job, current_user.id, params[:comment][:body])
      respond_to do |format|
        if @comment.save
          if(!params[:comment][:parent_id])
            @job.create_activity key: "job.commented", owner: current_user, params: {id: @comment.id, title: @comment.title, body: @comment.body}
            format.html {
              redirect_to @job
              gflash :success => "Kommentar erfolgreich erstellt!"
            }
            format.json { render json: @comment, status: :created, location: @job }
          else
            format.html {
              redirect_to @job
              gflash :success => "Antwort erstellt!"
            }
            @parent_comment = Comment.find(params[:comment][:parent_id])
            @comment.move_to_child_of(@parent_comment)
            format.json { render json: @comment, status: :created, location: @job }
          end
        else
          format.html {
            redirect_to @job
            gflash :error => "Senden des Kommentars fehlgeschlagen!"
          }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @job, notice: 'Comment was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end
end
