class UserSessionsController < ApplicationController
  before_filter :authenticate, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      #redirect_to user_path(current_user)
      redirect_to passages_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    #redirect_to new_user_session_path
    redirect_to login_path
  end
end
