# frozen_string_literal: true

class EntriesController < ApplicationController
  before_action :validate_session!

  def index
    intro(kind: 'Painel', ico_class: 'ls-ico-dashboard', href: root_path)
    @expenses            = Entry.expense.where(user_id: current_user.id).order(entry_date: :desc, created_at: :desc)
    @revenues            = Entry.revenue.where(user_id: current_user.id).order(entry_date: :desc, created_at: :desc)
    @balance             = @revenues.map(&:amount).reduce(&:+).to_f - @expenses.map(&:amount).reduce(&:+).to_f
    @color_class         = (@balance == 0.0) ? 'ls-color-theme' : ((@balance < 0.0) ? 'ls-color-danger' : 'ls-color-success')

    @today_expense       = @expenses.where(entry_date: DateTime.now.at_beginning_of_day..DateTime.now).map(&:amount).reduce(&:+).to_f
    @today_revenue       = @revenues.where(entry_date: DateTime.now.at_beginning_of_day..DateTime.now).map(&:amount).reduce(&:+).to_f
    @today_balance       = @today_revenue - @today_expense
    @today_color_class   = (@today_balance == 0.0) ? 'ls-color-theme' : ((@today_balance < 0.0) ? 'ls-color-danger' : 'ls-color-success')
  end

  def expenses
    new_entry('expense')
    @categories = Category.ordered
    intro(kind: 'Despesas', ico_class: 'ls-ico-cart', href: entries_path(current_user.id))
    @entries = Entry.expense.where(user_id: current_user.id).order(entry_date: :desc, created_at: :desc)
  end

  def revenues
    new_entry('revenue')
    @categories = Category.ordered
    intro(kind: 'Receitas', ico_class: 'ls-ico-chart-bar-up', href: entries_path(current_user.id))
    @entries = Entry.revenue.where(user_id: current_user.id).order(entry_date: :desc, created_at: :desc)
  end

  def show
    @entry = Entry.find params[:id]
    intro(kind:      'Detalhes de ' + (@entry.expense? ? 'despesa' : 'receita'),
          ico_class: (@entry.expense? ? 'ls-ico-cart' : 'ls-ico-bar-up'),
          href:      (@entry.expense? ? expenses_path(current_user.id) : revenues_path(current_user.id)))
  end

  def edit
    @entry = Entry.find params[:id]
    @categories = Category.ordered
    intro(kind:      'Edição de ' + (@entry.expense? ? 'despesa' : 'receita'),
          ico_class: (@entry.expense? ? 'ls-ico-cart' : 'ls-ico-bar-up'),
          href:      entry_path(@entry.id))
  end

  def update
    @entry = Entry.find params[:id]
    if @entry.update_attributes!(entry_params)
      flash[:notice] = (@entry.expense? ? 'despesa' : 'receita') + ' alterada com sucesso'
      redirect_to @entry
    else
      flash[:alert] = 'Algo deu errado'
      @categories = Category.ordered
      render :edit
    end
  end

  def create
    entry = Entry.new(entry_params)
    if entry.save
      flash[:notice] = 'Adicionada nova entrada'
        return redirect_to expenses_path(entry.user_id) if entry.expense?
        redirect_to revenues_path(entry.user_id)
    else
      flash.now[:alert] = 'Ops, algo está errado'
      new_entry(entry.kind)
      @categories = Category.ordered
      intro(kind:      entry.expense? ? 'Despesas' : 'Receitas',
            ico_class: 'ls-ico-stats',
            href:      entry.expense? ? expenses_path(current_user.id) : revenues_path(current_user.id))
      render :expenses
    end
  end

  def destroy
    entry = Entry.find params[:id]
    entry.destroy!

    flash[:notice] = 'Entrada apagada permanentemente!'
    if entry.expense?
      redirect_to expenses_path(entry.user_id)
    else
      redirect_to revenues_path(entry.user_id)
    end
  rescue
    flash.now['alert'] = 'Algo deu errado. Tente deletar a entrada novamente'
    return render :expenses if entry.expense?
    render :revenues
  end

  private

  def validate_session!
    raise ExpiredSessionError if current_user.blank?
  end

  def new_entry(kind)
    @entry = Entry.new(kind: kind)
  end

  def intro(kind:, ico_class:, href:)
    @intro = { message: kind, icoClass: ico_class, href: href }.to_json
  end

  def entry_params
    params.require(:entry)
      .permit(:category_id, :description, :entry_date, :kind)
      .merge(user_id: params[:user_id] || current_user.id)
      .merge(amount: parse_amount(params.dig(:entry, :currency)))
  end

  def parse_amount(input)
    BigDecimal(input.gsub('.', '').gsub(',', '.')).to_f
  end
end
