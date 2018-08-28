# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    render layout: 'access'
  end

  def create
    user = retrieve_user
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path(user.id)
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
      .where(email: params[:access], active: true)
      .or(User.where(username: params[:access], active: true))
      .first
  end
end
