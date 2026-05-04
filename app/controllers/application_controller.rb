# Base controller for all application controllers.
# Enforces authentication globally via require_login before_action.
# Exposes current_user and logged_in? as view helpers.
# Controllers that need admin-only access call require_admin explicitly.
class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :require_login

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  # Redirects to login unless a valid session exists. Applied to all controllers
  # by default; skip with skip_before_action :require_login for public actions.
  def require_login
    redirect_to login_path, alert: "Please log in to continue." unless logged_in?
  end

  # Redirects non-admin users to root. Called explicitly in controllers that
  # require admin-only access (e.g. UsersController).
  def require_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
