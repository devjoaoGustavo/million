class WalletsController < ApplicationController
  def index
    @wallets = WalletDecorator.decorate_collection current_user.wallets
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
      end
    end
  end

  private

  def update_params
    params
      .require(:wallet)
      .permits(:name)
  end
end
