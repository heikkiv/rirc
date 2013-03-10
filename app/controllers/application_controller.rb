class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin?
    session[:password] == ENV['ADMIN_PASSWORD']
  end

  def require_login
    unless admin?
      flash[:error] = "Unauthorized access"
      redirect_to '/login'
      false
    end
  end

end
