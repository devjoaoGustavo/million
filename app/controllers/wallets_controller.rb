class WalletsController < ApplicationController
  def index
    @wallets = WalletDecorator.decorate_collection current_user.wallets
  end
end
