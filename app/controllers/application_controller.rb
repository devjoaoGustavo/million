# frozen_string_literal: true

require 'helpers/timing'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_raven_context

  rescue_from ExpiredSessionError, with: :redirect_to_login

  def validate_session!
    raise ExpiredSessionError if current_user.blank?
  end

  private

  def redirect_to_login
    flash[:notice] = 'Sessão expirada. Faça o login novamente'
    redirect_to login_path
  end

  def set_raven_context
    Raven.user_context(id: session[:user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  alias_method :logged_in?, :current_user

  helper_method :logged_in?, :current_user
end
