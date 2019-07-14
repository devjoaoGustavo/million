# frozen_string_literal: true

class SharingsController < ApplicationController
  def new
    @wallet = Wallet.find(params[:wallet_id])
  end

  def create
    wallet = Wallet.find(params[:wallet_id])

    sharing = User
      .where(email: params[:contact])
      .or(User.where(username: params[:contact]))
      .first
      .then do |user|
      next if user.blank?

      existent = Sharing.find_by(user_id: user.id, wallet_id: wallet.id)
      next existent if existent.present?

      wallet
        .sharings
        .build(user_id: user.id)
    end

    if sharing&.new_record?
      if sharing.save
        redirect_to(
          user_wallets_path(current_user),
          notice: "Carteira #{sharing.wallet.name} compartilhada com #{sharing.user.presentation_name}"
        )
      else
        redirect_to(
          new_wallet_sharing_path(params[:wallet_id]),
          alert: "Não foi possível compartilhar a carteira '#{wallet.name}' com o usuário '#{params[:contact]}'"
        )
      end
    else
      if sharing
        redirect_to(
          user_wallets_path(current_user),
          notice: "A Carteira #{sharing.wallet.name} já está sendo compartilhada com #{sharing.user.presentation_name}"
        )
      else
        redirect_to(
          new_wallet_sharing_path(params[:wallet_id]),
          alert: "O usuário '#{params[:contact]}' não foi encontrado"
        )
      end
    end
  end

  def destroy
    sharing = Sharing.find(params[:id])
    if sharing.delete
      redirect_to user_wallets_path(current_user), notice: "Compartilhamento cancelado"
    else
      redirect_to user_wallets_path(current_user), alert: "Não foi possível cancelar o compartilhamento"
    end
  end
end
