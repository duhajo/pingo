class DashboardController < ApplicationController
  before_filter :require_user, :only => :index
  def index
    @user = User.find(@current_user.id)
    @skills = @user.tag_counts_on(:skills)
    @jobs = Job.tagged_with(@skills, :any => true).by_join_date
  end
end
