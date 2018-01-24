class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  alias_method :logged_in?, :current_user

  helper_method :logged_in?, :current_user
end
