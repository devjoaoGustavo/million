# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    render layout: 'access'
  end

  def google_auth
    access_token = request.env['omniauth.auth']
    @user = User.from_omniauth(access_token)
    @user.google_token = access_token.credentials.token
    refresh_token = access_token.credentials.refresh_token
    @user.google_refresh_token = refresh_token if refresh_token.present?

    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path(@user.id), notice: 'Acesso iniciado. É bom te ver por aqui!'
    else
      cookies.delete :_million_session
      redirect_to login_url, alert: @user.errors.full_messages.join("; \n")
    end
  end

  def create
    user = retrieve_user
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path(user.id), notice: 'Acesso iniciado. É bom te ver por aqui!'
    else
      flash.now[:alert] = 'Verifique se os dados de acesso estão corretos ou se o usuário está ativo'
      render :new,  layout: 'access'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  private

  def retrieve_user
    User
      .where(email: params[:access])
      .or(User.where(username: params[:access]))
      .first
  end
end
