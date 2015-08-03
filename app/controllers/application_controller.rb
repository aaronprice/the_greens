class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_filter :load_site_from_subdomain

  def login_as(user)
    session[:auth_token] = user.email
    current_user
  end

  def logout
    session[:auth_token] = nil
  end

  def current_user
    @current_user ||= User.find_by(email: session[:auth_token])
  end

  def require_auth
    if current_user.blank?
      redirect_to new_session_path
    end
  end

  def load_site_from_subdomain
    @site = Site.find_by!(slug: request.subdomain)
  rescue ActiveRecord::RecordNotFound
    raise ActionController::RoutingError.new('Not Found')
  end
end
