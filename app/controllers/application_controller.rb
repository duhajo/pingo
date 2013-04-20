class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time  
  protect_from_forgery
  force_ssl
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end
  
  helper_method :current_user
end
