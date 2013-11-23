class UsersController < ApplicationController

  def index
    @users = User.all
    @tags = User.tag_counts_on(:skills)
    @similar_users = current_user.find_related_skills.to_a
    if params[:search].present?
      if current_user
        @radius = User.find(current_user.id).radius
      end
      if(@radius.nil?)
        @near_users = User.near(params[:search], 10, :order => :distance)
      else
        @near_users = User.near(params[:search], @radius, :order => :distance)
      end
    end
  end

  def my_profile
    @user = User.find(current_user.id)
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @similar_users = @user.find_related_skills.to_a

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to :myprofile, notice: 'Your profile successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def tag
    @tag = Tag.find(params[:id])
    @workers = User.tagged_with(@tag.name)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end

  end

end
