class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def login_as(user)
    session[:auth_token] = user.email
  end

  def current_user
    @current_user ||= User.find_by(email: session[:auth_token])
  end
end
