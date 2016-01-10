class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  protect_from_forgery
  force_ssl

  helper :all # include all helpers, all the time
  helper_method :my_jobs
  helper_method :init_chats

  private

  before_filter :set_locale

  def auth_user
    redirect_to new_user_registration_url unless user_signed_in?
  end

  def set_locale
    I18n.locale = user_signed_in? ? current_user.locale.to_sym : I18n.default_locale
  end

  def my_jobs
    @my_jobs = Job.where(:user_id => @current_user.id).to_a
  end

  def init_chats
    if user_signed_in?
      @init_chats = Conversation.involving(@current_user)
    end
  end

end
