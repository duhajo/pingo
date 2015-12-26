class TagsController < ApplicationController

  def index
    @tags = Tag.tags(:limit => 100, :order => "name desc")
  end

  def show
    @tag = Tag.find(params[:id])

    @users = User.tagged_with(@tag.name)
    @supplies = Job.tagged_with(@tag.name).where(:type => 1)
    @demands = Job.tagged_with(@tag.name).where(:type => 2)

    @rel_tags_users = @users.collect{|x|x.skills}.flatten
    @rel_tags_supplies = @supplies.collect{|x|x.skills}.flatten
    @rel_tags_demands = @demands.collect{|x|x.skills}.flatten
    @related_tags = (@rel_tags_users + @rel_tags_supplies + @rel_tags_demands).uniq
    @related_tags.delete(@tag)

    respond_to do |format|
      format.html # show.html.erb.erb
      format.json { render json: @tag }
    end
  end
end
