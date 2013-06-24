class JobsController < ApplicationController

  before_filter :require_user, :only => :new

  # GET /jobs
  # GET /jobs.json
  def index
  
  if params[:search].present?
    if(current_user)
      @radius = User.find(current_user.id).radius
    end
    if(@radius.nil?)
      @near_jobs = Job.near(params[:search], 10, :order => :distance)
    else
      @near_jobs = Job.near(params[:search], @radius, :order => :distance)
    end
    @jobs = Job.find_all_by_parent_id(nil);
  else
    @jobs = Job.find_all_by_parent_id(nil);
  end

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @jobs }
    #end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])
    @jobs = Job.find_all_by_parent_id(@job.id);
    @activities = @job.activities.all
    @json = @job.to_gmaps4rails
    @workers = User.joins(:jobs_workers)
    .where('jobs_workers.job_id' => @job.id)
    .select("name, id, jobs_workers.isCreator").to_a

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
    @job = Job.new
    
    respond_to do |format|
       format.html # new.html.erb
       format.json { render json: @job }
    end
  end

  def child
    render :create
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(params[:job])
    @job.jobs_workers.build( :user_id => current_user.id, :isCreator => true)

    respond_to do |format|
      if @job.save
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
      if @job.update_attributes(params[:job])
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
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
      JobsWorker.where('jobs_workers.job_id' => @job.id).where('jobs_workers.user_id' => current_user.id).first_or_create()
    else
      @job.users.delete(current_user)
    end
    
    respond_to do |format|
      format.html { redirect_to @job }
      format.json { head :no_content }
    end
  end

end
