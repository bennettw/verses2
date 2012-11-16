class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user

  protected
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  def authenticate
    unless current_user
      flash[:notice] = "You're not logged in."
      redirect_to login_url
      return false
    end
  end


  def require_user
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      # TODO: store in session the page they requested
      return false
    end
  end

end
