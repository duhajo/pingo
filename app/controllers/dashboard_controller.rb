class DashboardController < ApplicationController
  before_filter :require_user, :only => :index
  def index
    @user = User.find(@current_user.id)
    @skills = @user.tag_counts_on(:skills)
    @recommendations = Job.tagged_with(@skills, :any => true).by_join_date
    
    @my_activities = Activity.joins("LEFT JOIN `jobs_workers` ON activities.job_id = jobs_workers.job_id").where('jobs_workers.user_id' => @current_user.id).to_a
    
  end
end
