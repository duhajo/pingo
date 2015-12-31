class JobsController < ApplicationController

  before_filter :authenticate_user!, :only => :new
  protect_from_forgery :except => :index
  uploads_nicedit_image :upload_action_name

  autocomplete :job, :title, :full => true

  # GET /jobs
  # GET /jobs.json
  def index
    if params[:job_id]
      @job = Job.find(params[:job_id])
      redirect_to @job
    elsif params[:scope]
      if params[:scope] == "categories"
        @categories = Job.where('parent_id' => nil, 'type' => 0)
        @unsorted_job_tags = Job.where(type: [1,2], parent_id: nil).skill_counts.order('count desc').limit(5)
        respond_to do |format|
          format.html {
            render :partial => 'categories_overview', :categories => @categories, :unsorted_job_tags => @unsorted_job_tags
          }
        end
      elsif params[:scope] == "unsorted"
        @supplies = Job.where(type: 1, parent_id: nil).joins(:user).select("jobs.*, users.email as user_email, users.name as user_name, users.id as user_id")
        @demands = Job.where(type: 2, parent_id: nil).joins(:user).select("jobs.*, users.email as user_email, users.name as user_name, users.id as user_id")
        @most_used_tags = Job.where(type: [1,2], parent_id: nil).skill_counts.order('count desc').limit(15)

        if params[:jobs_filter].present?
          @supplies = @supplies.where('lower(title) LIKE ?', "%#{params[:jobs_filter].downcase}%")
          @demands = @demands.where('lower(title) LIKE ?', "%#{params[:jobs_filter].downcase}%")
        end

        respond_to do |format|
          format.html {
            render 'unsorted_jobs.erb', :demands => @demands, :supplies => @supplies, :most_used_tags => @most_used_tags
          }
        end
      else
        @supplies = Job.where(type: 1).joins(:user).select("jobs.*, users.email as user_email, users.name as user_name, users.id as user_id")
        @demands = Job.where(type: 2).joins(:user).select("jobs.*, users.email as user_email, users.name as user_name, users.id as user_id")

        if params[:jobs_filter].present?
          @supplies = @supplies.where('lower(title) LIKE ?', "%#{params[:jobs_filter].downcase}%")
          @demands = @demands.where('lower(title) LIKE ?', "%#{params[:jobs_filter].downcase}%")
        end

        respond_to do |format|
          format.html {
            render :partial => 'jobs_overview', :supplies => @supplies, :demands => @demands
          }
        end
      end
    else
      @categories = Job.where('parent_id' => nil, 'type' => 0)
      @unsorted_job_tags = Job.where(type: [1,2], parent_id: nil).skill_counts.order('count desc').limit(5)
    end
  end

  def get_conversations(job)
    if current_user
      if @is_manager
        return Conversation.job_involving(current_user, job) #ToDo
      else
        return Conversation.job_involving(current_user, job)
      end
    else
      return nil
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])

    @is_manager = Job.is_creator_of_job(@job, current_user)
    @manager = User.find(@job.user_id)

    if @job.parent_id
      @parent_jobs = @job.ancestors
    end

    @all_jobs = Job.where('parent_id' => @job.id)

    if @job.type == 0
      @most_used_tags = @all_jobs.skill_counts
      @categories = @all_jobs.where('type' => 0)
      @supplies = @all_jobs.where(type: 1).joins(:user).select("jobs.*, users.email as user_email, users.name as user_name, users.id as user_id")
      @demands = @all_jobs.where(type: 2).joins(:user).select("jobs.*, users.email as user_email, users.name as user_name, users.id as user_id")
      if params[:jobs_filter].present?
        @supplies = @supplies.where('lower(title) LIKE ?', "%#{params[:jobs_filter].downcase}%")
        @demands = @demands.where('lower(title) LIKE ?', "%#{params[:jobs_filter].downcase}%")
      end
    else
      @job_ids = Array.new << @job.id
      @all_jobs.each do |job|
        @job_ids << job.id
      end
      @activities = PublicActivity::Activity.order("created_at DESC").all(:conditions => {trackable_type: "Job", trackable_id: [@job_ids] })
      @comment = Comment.new
      @comments = @job.comment_threads

      @conversations = get_conversations(@job.id)
      @job_chat_active = true

      @job_files = JobsFiles.find_all_by_job_id(@job.id)

      @file_others , @file_images = [], []
      @job_files.each do |attachment|
        @file_images << attachment if ((attachment.file.content_type || "").split("/").first == 'image')
        @file_others << attachment if ((attachment.file.content_type || "").split("/").first != 'image')
      end
    end
    respond_to do |format|
      format.html # show.html.erb.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    if params[:id]
       @parent_job = Job.find(params[:id])
    end

    if params[:type].present?
      @type = 0 if params[:type] == 'category'
      @type = 1 if params[:type] == 'supply'
      @type = 2 if params[:type] == 'demand'
    else
      @type = false
    end

    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new_file
    @job = Job.find(params[:id])
    @job_file = JobsFiles.new(params[:jobs_files])
    @job_file.user_id = current_user.id
    @job_file.job_id = @job.id

    respond_to do |format|
      if @job_file.save
        @job.create_activity :upload_file, params: {file: @job_file.id}, owner: current_user
        format.html { redirect_to @job, notice: 'File was uploaded successfully.' }
        format.json { render json: @job, status: :created, location: @job }
      end
    end
  end

  def child
    render :create
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    @is_manager = Job.is_creator_of_job(@job, current_user)

    if @job.type == 0
      @type = 0
    elsif @job.type == 1 || @job.type == 2
      @type = 2
    else
      @type = 1
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(params[:job])
    @job.user_id = current_user.id

    respond_to do |format|
      if @job.save
        @job.reload
        if @job.parent_id
	        @job.create_activity :create_child, params: {job: Job.find(@job.parent_id)}, owner: current_user
	      else
          @job.create_activity :create, owner: current_user
        end
        #ToDo: Add Type Distinction ("add Resource ABC to category XYZ")
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render json: @job, status: :created, location: @job }
      else
        format.html { render action: "new" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    @job = Job.find(params[:id])
    respond_to do |format|
      if @job.update_attributes(params[:job].except(:user_list, :manager_ids))
        format.html { redirect_to @job, notice: 'Job was successfully updated.'}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job = Job.find(params[:id])
    @activities = PublicActivity::Activity.find_by_trackable_id(@job.id)
    @activities.destroy
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  def get_tags
    @job = Job.find(params[:id])
    @tags = @job.tag_counts_on(:skills, :limit => 5, :order => "count desc")
  end

  def set_status
    @job = Job.find(params[:id])
    @is_manager = Job.is_creator_of_job(@job, current_user)
    if @is_manager
      @job.status = params[:status]
      @job.save()
    end

    respond_to do |format|
      format.html {
        render :partial => 'status', :job => @job, :is_manager => @is_manager
      }
      format.json { head :no_content }
      format.js {}
    end
  end

  def map_for_job
    @job = Job.find(params[:id])
    @lat = @job.latitude
    @long = @job.longitude
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render :action => 'map', :job => @job }
    end
  end
end
