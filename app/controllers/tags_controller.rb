class TagsController < ApplicationController

  def index
    @tags = Tag.tags(:limit => 100, :order => "name desc")
  end

  def show
    @tag = Tag.find(params[:id])

    @workers = User.tagged_with(@tag.name)
    @jobs = Job.tagged_with(@tag.name)

    respond_to do |format|
      format.html # show.html.erb.erb
      format.json { render json: @tag }
    end
  end
end
