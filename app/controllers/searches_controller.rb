class SearchesController < ApplicationController
  def index
    if params[:search]
      @jobs = Job.search(params[:search])
    end
    respond_to do |format|
      format.html
    end
  end
end
