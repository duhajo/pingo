class TagsController < ApplicationController

  def index
    @tags = Tag.tags(:limit => 100, :order => "name desc")
  end

  def show
    @tag = Tag.find(params[:id])

    @users = User.tagged_with(@tag.name)
    @supplies = Pin.tagged_with(@tag.name).where(:type => 1).joins(:user).select("pins.*, users.email as user_email, users.name as user_name, users.id as user_id")
    @demands = Pin.tagged_with(@tag.name).where(:type => 2).joins(:user).select("pins.*, users.email as user_email, users.name as user_name, users.id as user_id")

    @rel_tags_users = @users.collect{|x|x.skills}.flatten
    @rel_tags_supplies = @supplies.collect{|x|x.skills}.flatten
    @rel_tags_demands = @demands.collect{|x|x.skills}.flatten
    @related_tags = (@rel_tags_users + @rel_tags_supplies + @rel_tags_demands).uniq
    @related_tags.delete(@tag)

    if params[:pins_filter].present?
      @supplies = @supplies.where('lower(title) LIKE ?', "%#{params[:pins_filter].downcase}%")
      @demands = @demands.where('lower(title) LIKE ?', "%#{params[:pins_filter].downcase}%")
    end

    respond_to do |format|
      format.html # show.html.erb.erb
      format.json { render json: @tag }
    end
  end
end
