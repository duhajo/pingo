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
       #format.html {render :partial => "comments/reply"}
       format.js
    end
  end
  
  # POST /comments
  # POST /comments.json
  def create
    @job = Job.find(params[:job_id])
    @comment = Comment.build_from(@job, current_user.id, params[:comment][:body])

    respond_to do |format|
      if @comment.save
        if(!params[:comment][:parent_id])
          @job.create_activity key: "job.commented", owner: current_user, params: {id: @comment.id, title: @comment.title, subject: @comment.subject, body: @comment.body}
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
