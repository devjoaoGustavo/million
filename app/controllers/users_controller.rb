class UsersController < ApplicationController
  def new
    @user = User.new
    render layout: 'access'
  end

  def create
    @user = User.new(allowed_params)
    if @user.activate!
      UserMailer.welcome_email(@user).deliver_now
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Cadastro efetivado com sucesso. Enviaremos um email para a ativação da sua conta!'
    else
      flash.now[:alert] = 'Verifique os dados e tente novamente'
      render :new, layout: 'access'
    end
  end

  def confirm
    @user = User.find(params[:id])
    if @user.activate!
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Você está dentro. Bom te ter por aqui!'
    else
      redirect_to login_path, alert: 'Algo deu errado durante a ativação de sua conta. Tente fazer o login, por favor.'
    end
  end

  def recover
    render layout: 'access'
  end

  def send_email_for_recover
    @user = User.find_by_email params[:email]
    if @user.present?
      UserMailer.recover_email(@user).deliver_now
      redirect_to login_path, notice: 'Enviamos um email para você redefinir sua senha.'
    else
      flash.now[:alert] = 'O email informado ainda não foi cadastrado'
      render :recover, layout: 'access'
    end
  end

  def redefine_password
    @user = User.find params[:id]
    render layout: 'access'
  end

  def redefine
    @user = User.find params[:id]
    @user.password              = allowed_params[:password]
    @user.password_confirmation = allowed_params[:password_confirmation]
    if @user.activate!
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Senha redefinida com sucesso.'
    else
      flash.now[:alert] = 'Algo deu errado'
      render :redefine_password, layout: 'access'
    end
  end

  private

  def allowed_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
