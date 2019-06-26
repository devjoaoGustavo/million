# frozen_string_literal: true

class WalletDecorator < ApplicationDecorator
  include Timing
  delegate_all

  def balance
    @balance ||= revenues_till_now.sum(&:amount) - expenses_till_now.sum(&:amount)
  end

  def revenues_till_now
    @revenues_till_now ||= Entry::Revenue
      .by_wallet(id)
      .order(entry_date: :desc)
  end

  def expenses_till_now
    @expenses_till_now ||= Entry::Expense
      .by_wallet(id)
      .order(entry_date: :desc)
  end
end
