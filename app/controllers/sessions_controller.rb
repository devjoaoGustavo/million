class SessionsController < ApplicationController
  def create
    user = retrieve_user
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in!'
    else
      flash.now[:alert] = 'username, email or password incorrect'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'logged out successfully'
  end

  private

  def retrieve_user
    User
      .where(email: params[:access])
      .or(User.where(username: params[:access]))
      .first
  end
end
