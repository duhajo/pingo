class JobWorkersController < ApplicationController
  # GET /job_workers
  # GET /job_workers.json
  def index
    @job_workers = JobWorker.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @job_workers }
    end
  end

  # GET /job_workers/1
  # GET /job_workers/1.json
  def show
    @job_worker = JobWorker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job_worker }
    end
  end

  # GET /job_workers/new
  # GET /job_workers/new.json
  def new
    @job_worker = JobWorker.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job_worker }
    end
  end

  # GET /job_workers/1/edit
  def edit
    @job_worker = JobWorker.find(params[:id])
  end

  # POST /job_workers
  # POST /job_workers.json
  def create
    @job_worker = JobWorker.new(params[:job_worker])

    respond_to do |format|
      if @job_worker.save
        format.html { redirect_to @job_worker, notice: 'Job worker was successfully created.' }
        format.json { render json: @job_worker, status: :created, location: @job_worker }
      else
        format.html { render action: "new" }
        format.json { render json: @job_worker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /job_workers/1
  # PUT /job_workers/1.json
  def update
    @job_worker = JobWorker.find(params[:id])

    respond_to do |format|
      if @job_worker.update_attributes(params[:job_worker])
        format.html { redirect_to @job_worker, notice: 'Job worker was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job_worker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_workers/1
  # DELETE /job_workers/1.json
  def destroy
    @job_worker = JobWorker.find(params[:id])
    @job_worker.destroy

    respond_to do |format|
      format.html { redirect_to job_workers_url }
      format.json { head :no_content }
    end
  end
end
