class SessionsController < ApplicationController

  def new
  end

  def create
    session[:password] = params[:password]
    flash[:notice] = "Successfully logged in"
    redirect_to :controller => "messages", :action => "index"
  end

  def destroy
    reset_session
    flash[:notice] = "Successfully logged out"
    redirect_to :controller => "sessions", :action => "new"
  end

end
