class JobsController < ApplicationController

  before_filter :authenticate_user!, :only => :new
  protect_from_forgery :except => :index
  uploads_nicedit_image :upload_action_name

  # GET /jobs
  # GET /jobs.json
  def index

  #if params[:search].present?
  #  if current_user
  #    @radius = User.find(current_user.id).radius
  #  end
  #  if(@radius.nil?)
  #    @near_jobs = Job.near(params[:search], 10, :order => :distance)
  #  else
  #    @near_jobs = Job.near(params[:search], @radius, :order => :distance)
  #  end
  #  @jobs = Job.find_all_by_parent_id(nil)
  #else
  #  @jobs = Job.find_all_by_parent_id(nil)
  #  @jobs_voted = Job.joins("LEFT JOIN `votes` ON votes.votable_id = jobs.id").select("jobs.id, status, title, deadline, COUNT(votes.votable_id) as votes_count").where("votes.vote_flag" => true).group("votes.votable_id").order("votes_count desc,votes.updated_at desc,jobs.updated_at desc").all()
  #end
    
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @jobs }
    #end
    @demands = Job.where('parent_id' => nil).where('type' => 1)
    @supplies = Job.where('parent_id' => nil).where('type' => 2)
    @categories = Job.find_all_by_type(0)
  end

  def get_user_role(job)
    if current_user
      if job.users.find_by_id(current_user.id)
        unless JobsWorker.where(:job_id => job.id).where('jobs_workers.isCreator' => true).where(:user_id => current_user.id).to_a.empty?
          return 3 #manager
        else
          return 2 #worker
        end
      else
        return 1 #keine role
      end
    else
      return 0
    end
  end
  
  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])
    @job_files = JobsFiles.find_all_by_job_id(@job.id)

    @file_others , @file_images = [], []
    @job_files.each do |attachment|
      @file_images << attachment if ((attachment.file.content_type || "").split("/").first == 'image')
      @file_others << attachment if ((attachment.file.content_type || "").split("/").first != 'image')
    end

    @user_role = get_user_role(@job)
    @is_manager = JobsWorker.where(:job_id => @job.id).where('jobs_workers.isCreator' => true).to_a
    
    @all_jobs = Job.where('parent_id' => @job.id)
    @demands = @all_jobs.where('type' => 1)
    @supplies = @all_jobs.where('type' => 2)
    
    @parent_jobs = @job.ancestors
    @job_ids = Array.new << @job.id
    @all_jobs.each do |job|
      @job_ids << job.id
    end
    @activities = PublicActivity::Activity.order("created_at DESC").all(:conditions => {trackable_type: "Job", trackable_id: [@job_ids] })
    @comment = Comment.new
    @comments = @job.comment_threads
    @workers = User.joins(:jobs_workers)
    .where('jobs_workers.job_id' => @job.id)
    .select("name, id, email, isCreator").to_a
    
    if @job.type == 0
      @most_used_tags = @all_jobs.skill_counts
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    if params[:id]
       @parent_job = Job.find(params[:id])
    end
    
    @type = 0 if params[:type].present?
    
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
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
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
    @managers = User.joins(:jobs_workers).select("users.id, name, email").where("jobs_workers.job_id" => @job.id).where("jobs_workers.isCreator" => true).to_a
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(params[:job])
    @job.jobs_workers.build( :user_id => current_user.id, :isCreator => true)

    respond_to do |format|
      if @job.save
        if @job.parent_id
	        @job.create_activity :create_child, params: {job: Job.find(@job.parent_id)}, owner: current_user
	      else
          @job.create_activity :create, owner: current_user
	      end
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
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  def support
    @job = Job.find(params[:id])
    if params[:support]
      if params[:manager]
        @current_worker = @job.jobs_workers.where(:user_id => current_user.id)
        if @current_worker.empty?
          @job.jobs_workers.where(:user_id => current_user.id).where(:isCreator => true).first_or_create()
        else
          @current_worker.update_all(:isCreator => 1)
        end
      else
        @job.jobs_workers.where(:user_id => current_user.id).first_or_create()
      end
    else
      @job.users.delete(current_user)
    end

    respond_to do |format|
      format.html { redirect_to @job }
      format.json { head :no_content }
    end
  end

  def get_tags
    @job = Job.find(params[:id])
    @tags = @job.tag_counts_on(:skills, :limit => 5, :order => "count desc")
  end

  def set_status
    @job = Job.find(params[:id])
    @user_role = get_user_role(@job)
    @managers = JobsWorker.where(:job_id => @job.id).where('jobs_workers.isCreator' => true).where(:user_id => current_user.id)
    unless @managers.empty?
      @job.status = params[:status]
      @job.save()
    end

    respond_to do |format|
      format.html {
        render :partial => 'status', :job => @job, :manager => @managers
      }
      format.json { head :no_content }
      format.js {}
    end
  end

  def like
    @job = Job.find(params[:id])
    if current_user
      unless current_user.voted_as_when_voted_for @job
        current_user.likes @job
        @job.save()
      else
        current_user.dislikes @job
        @job.save()
      end
    end

    respond_to do |format|
      format.json { render :json => @job.likes.size }
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

  def show_manager_list
    @job = Job.find(params[:id])
    unless JobsWorker.where(:job_id => @job.id).where('jobs_workers.isCreator' => true).where(:user_id => current_user.id).to_a.empty?
      @user_is_manager = true
    end
    @managers = User.joins(:jobs_workers).select("users.id, name, email").where("jobs_workers.job_id" => @job.id).where("jobs_workers.isCreator" => true).to_a
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
  
  def edit_manager_list 
    @job = Job.find(params[:id])
    @user_id = params[:user_id].to_i

    if(params[:remove] && params[:remove] == "true")
      @job.jobs_workers.where(:user_id => @user_id).update_all(:isCreator => 0)
    else
      @job_worker = @job.jobs_workers.where(:user_id => @user_id)
      if(@job_worker.empty?)
        JobsWorker.where('jobs_workers.job_id' => @job.id).where('jobs_workers.user_id' => @user_id).where('jobs_workers.isCreator' => true).first_or_create()
      else
        @job_worker.update_all(:isCreator => 1)
      end
    end
    
    unless JobsWorker.where(:job_id => @job.id).where('jobs_workers.isCreator' => true).where(:user_id => current_user.id).to_a.empty?
      @user_is_manager = true
    end
    
    @managers = User.joins(:jobs_workers).select("users.id, name, email").where("jobs_workers.job_id" => @job.id).where("jobs_workers.isCreator" => true).to_a
    
    respond_to do |format|
      format.js
    end
  end
end
