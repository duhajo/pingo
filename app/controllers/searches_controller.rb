class SearchesController < ApplicationController

  def index
    if params[:search]
      @search = params[:search]
      if !@search.blank?
        @pins = Pin.search(params[:search])
        @tags = Tag.search(params[:search])
      end
    end
    respond_to do |format|
      format.html
    end
  end
end
