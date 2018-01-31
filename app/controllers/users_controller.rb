class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      redirect_to root_path, notice: "You're signed up! We send you an email with a link for activate your account!"
    else
      flash.now[:alert] = 'Something wrong. try again'
      render :new
    end
  end

  def confirm
    @user = User.find(params[:id])
    if @user.activate!
      session[:user_id] = @user.id
      redirect_to root_path, notice: "You're in!"
    else
      redirect_to login_path, alert: 'Something went wrong while activating your account, try to login, please.'
    end
  end

  private

  def allowed_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
