class UsersController < ApplicationController
  def new
    @user = User.new
    render layout: 'access'
  end

  def create
    @user = User.new(allowed_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      redirect_to root_path, notice: 'Acabei de te cadastrar. Te enviarei um email com um link para a ativação da seu conta!'
    else
      flash.now[:alert] = 'Verifique os dados e tente novamente'
      render :new, layout: 'access'
    end
  end

  def confirm
    @user = User.find(params[:id])
    if @user.activate!
      session[:user_id] = @user.id
      redirect_to root_path, notice: " Você está dentro. Bom te ter por aqui!"
    else
      redirect_to login_path, alert: 'Algo deu errado durante a ativação de sua conta. Tente fazer um login, por favor.'
    end
  end

  private

  def allowed_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
