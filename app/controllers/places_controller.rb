class PlacesController < ApplicationController
  def index
    @jobs = Job.where("longitude IS NOT NULL AND latitude IS NOT NULL").all
    @geojson = Array.new

    @jobs.each do |job|
      @geojson << {
          longitude: job.longitude,
          latitude: job.latitude,
          title: job.title,
          job_id: job.id,
          url: job_path(job.id)
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end

  end
end
