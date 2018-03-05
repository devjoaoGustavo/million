# frozen_string_literal: true

class EntriesController < ApplicationController
  def expenses
    new_entry('expense')
    intro(kind: 'Despesas', ico_class: 'ls-ico-cart')
    @expenses = Entry.where(kind: :expense).order(entry_date: :desc)
  end

  def create
    entry = Entry.new(entry_params)
    if entry.save
      flash[:notice] = 'Adicionada nova entrada'
      redirect_to expenses_path(entry.user_id) if entry.expense?
    else
      flash.now[:alert] = 'Algo errado'
      new_entry(entry.kind)
      intro(kind:      entry.expense? ? 'Despesas' : 'Receitas',
            ico_class: 'ls-ico-stats')
      render :expenses
    end
  end

  private

  def new_entry(kind)
    @new_entry = Entry.new(kind: kind)
  end

  def intro(kind:, ico_class:)
    @intro = { message: kind, icoClass: ico_class }.to_json
  end

  def entry_params
    params.require(:entry)
      .permit(:category_id, :description, :entry_date, :kind)
      .merge(user_id: params[:user_id])
      .merge(amount: parse_amount(params.dig(:entry, :amount)))
  end

  def parse_amount(input)
    BigDecimal(input.gsub('.', '').gsub(',', '.')).to_f
  end
end
