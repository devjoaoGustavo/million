class WalletsController < ApplicationController
  def index
    @wallets = WalletDecorator.decorate_collection current_user.wallets
  end

  def new
    @wallet = current_user.wallets.build(name: '')
  end

  def create
    wallet = Wallet.new(create_params)

    if wallet.save
      redirect_to user_wallets_path(current_user), notice: 'Carteira criada com sucesso'
    else
      flash.now[:alert] = 'A carteira não foi salva. Tente novamente'
      render :new
    end
  end

  def edit
    @wallet = Wallet
      .find(params[:id])
      .then do |wallet|
      WalletDecorator.decorate(wallet)
    end
  end

  def update
    Wallet.find(params[:id]).then do |wallet|
      if wallet.update(update_params)
        redirect_to user_wallets_path(current_user), notice: 'cateira atualizada'
      else
        flash.now[:alert] = "Algo não deu certo. Tente novamente"
        render :edit
      end
    end
  end

  private

  def create_params
    params
      .require(:wallet)
      .permit(:user_id, :name)
  end

  def update_params
    params
      .require(:wallet)
      .permit(:name)
  end
end
