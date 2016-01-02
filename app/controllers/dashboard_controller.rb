class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user = User.find(current_user.id)
    @skills = @user.tag_counts_on(:skills)
    @recommendations = Job.tagged_with(@skills, :any => true).joins(:user).select("jobs.*, users.email as user_email, users.name as user_name, users.id as user_id").by_join_date

    @my_activities = PublicActivity::Activity.order("created_at DESC").joins("LEFT JOIN jobs ON activities.trackable_id = jobs.id").where('jobs.user_id' => @current_user.id).all

    if(!@user.latitude.nil? and !@user.longitude.nil?)
      @center_point = [@user.latitude, @user.longitude]
      if(!@user.radius.nil?)
        @box = Geocoder::Calculations.bounding_box(@center_point, @user.radius)
      else
        @box = Geocoder::Calculations.bounding_box(@center_point, 10)
      end
      @near_jobs = Job.within_bounding_box(@box).joins(:user).select("jobs.*, users.email as user_email, users.name as user_name, users.id as user_id")
    end
  end
end
