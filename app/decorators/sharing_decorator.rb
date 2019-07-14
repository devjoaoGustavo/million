# frozen_string_literal: true

class SharingDecorator < ApplicationDecorator
  delegate_all

  def name
    "(de #{author_name}) #{wallet.name}"
  end

  def author_name
    author.presentation_name
  end

  def author
    wallet.user
  end

  def balance
    wallet.balance
  end

  def wallet
    WalletDecorator.decorate(object.wallet)
  end
end
