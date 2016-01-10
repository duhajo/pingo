class PlacesController < ApplicationController
  def index
    @pins = Pin.where("longitude IS NOT NULL AND latitude IS NOT NULL").all
    @geojson = Array.new

    @pins.each do |pin|
      @geojson << {
          longitude: pin.longitude,
          latitude: pin.latitude,
          title: pin.title,
          pin_id: pin.id,
          url: pin_path(pin.id)
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end

  end
end
