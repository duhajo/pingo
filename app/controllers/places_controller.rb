class PlacesController < ApplicationController
  def index
    @jobs = Job.where("longitude IS NOT NULL AND latitude IS NOT NULL").all
    @geojson = Array.new

    @jobs.each do |job|
      @geojson << {
          type: 'Feature',
          geometry: {
              type: 'Point',
              coordinates: [job.longitude, job.latitude]
          },
          properties: {
            title: job.title,
            address: job.street,
            :'marker-color' => '#00607d',
            :'marker-symbol' => 'circle',
            :'marker-size' => 'medium'
          }
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end

  end
end
