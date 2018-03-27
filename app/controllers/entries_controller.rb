# frozen_string_literal: true

class EntriesController < ApplicationController
  before_action :validate_session!
  before_action :load_expenses, only: [:expenses]
  before_action :load_revenues, only: [:revenues]
  before_action :load_categories, only: [:revenues, :expenses, :edit, :create, :update]
  rescue_from InvalidCurrencyFormat, with: :invalid_currency_format

  def index
    intro(message: 'Painel', ico_class: 'ls-ico-dashboard', href: root_path)
    @expenses    = Entry::Expense.where(user_id: current_user.id).order(entry_date: :desc, created_at: :desc)
    @revenues    = Entry::Revenue.where(user_id: current_user.id).order(entry_date: :desc, created_at: :desc)
    @balance     = @revenues.map(&:amount).reduce(&:+).to_f - @expenses.map(&:amount).reduce(&:+).to_f
    @color_class = (@balance == 0.0) ? 'ls-color-theme' : ((@balance < 0.0) ? 'ls-color-danger' : 'ls-color-success')

    @month_expense     = @expenses.where(entry_date: DateTime.current.at_beginning_of_month.utc..Time.current.utc).map(&:amount).reduce(&:+).to_f
    @month_revenue     = @revenues.where(entry_date: DateTime.current.at_beginning_of_month.utc..Time.current.utc).map(&:amount).reduce(&:+).to_f
    @month_balance     = @month_revenue - @month_expense
    @month_color_class = (@month_balance == 0.0) ? 'ls-color-theme' : ((@month_balance < 0.0) ? 'ls-color-danger' : 'ls-color-success')

    @seven_days_expense     = @expenses.where(entry_date: (DateTime.current - 7).at_beginning_of_day.utc..Time.current.utc).map(&:amount).reduce(&:+).to_f
    @seven_days_revenue     = @revenues.where(entry_date: (DateTime.current - 7).at_beginning_of_day.utc..Time.current.utc).map(&:amount).reduce(&:+).to_f
    @seven_days_balance     = @seven_days_revenue - @seven_days_expense
    @seven_days_color_class = (@seven_days_balance == 0.0) ? 'ls-color-theme' : ((@seven_days_balance < 0.0) ? 'ls-color-danger' : 'ls-color-success')

    @today_expense     = @expenses.where(entry_date: DateTime.current.at_beginning_of_day.utc..Time.current.utc).map(&:amount).reduce(&:+).to_f
    @today_revenue     = @revenues.where(entry_date: DateTime.current.at_beginning_of_day.utc..Time.current.utc).map(&:amount).reduce(&:+).to_f
    @today_balance     = @today_revenue - @today_expense
    @today_color_class = (@today_balance == 0.0) ? 'ls-color-theme' : ((@today_balance < 0.0) ? 'ls-color-danger' : 'ls-color-success')

    @expense_params = { size: { height: 300 }, chartId: 'expense-by-category' }.to_json
    @expense_data = Entry::Expense.where(user_id: current_user.id,
                                         entry_date: DateTime.current.at_beginning_of_month.utc..Time.current.utc).group_by(&:category_id).map do |k, v|
      expense_of_category = v.sum(&:amount)

      { category: Category.find(k).name, amount: sprintf("%.2f", expense_of_category) }
    end.to_json
    @revenue_params = { size: { height: 300 }, chartId: 'revenue-by-category' }.to_json
    @revenue_data = Entry::Revenue.where(user_id: current_user.id,
                                         entry_date: DateTime.current.at_beginning_of_month.utc..Time.current.utc).group_by(&:category_id).map do |k, v|
      expense_of_category = v.sum(&:amount)

      { category: Category.find(k).name, amount: sprintf("%.2f", expense_of_category) }
    end.to_json
  end

  def expenses
    new_entry('Entry::Expense')
    intro(message: 'Despesas', ico_class: 'ls-ico-cart', href: dashboard_path(current_user.id))
  end

  def revenues
    new_entry('Entry::Revenue')
    intro(message: 'Receitas', ico_class: 'ls-ico-chart-bar-up', href: dashboard_path(current_user.id))
  end

  def show
    @entry = find_entry
    intro(message:   'Detalhes de ' + (@entry.expense? ? 'despesa' : 'receita'),
          ico_class: (@entry.expense? ? 'ls-ico-cart' : 'ls-ico-bar-up'),
          href:      (@entry.expense? ? expenses_path(current_user.id) : revenues_path(current_user.id)))
  end

  def edit
    @entry = find_entry
    intro(message:   'Edição de ' + (@entry.expense? ? 'despesa' : 'receita'),
          ico_class: (@entry.expense? ? 'ls-ico-cart' : 'ls-ico-bar-up'),
          href:      entry_path(@entry.id))
  end

  def update
    @entry = find_entry
    if @entry.update_attributes!(entry_params)
      flash[:notice] = (@entry.expense? ? 'despesa' : 'receita') + ' alterada com sucesso'
      redirect_to @entry
    else
      flash[:alert] = 'A entrada não foi alterada. Verifique os valores e tente novamente'
      render :edit
    end
  end

  def create
    @entry = Entry.new(entry_params)
    if @entry.save
      flash[:notice] = 'Adicionada nova entrada'
      return redirect_to expenses_path(current_user.id) if @entry.expense?
      redirect_to revenues_path(current_user.id)
    else
      flash.now[:alert] = 'A entrada não foi salva. Verifique os valores e tente novamente'
      if @entry.expense?
        intro(message: 'Despesas', ico_class: 'ls-ico-cart', href: expenses_path(current_user.id))
        load_expenses
        render :expenses
      else
        intro(message: 'Receitas', ico_class: 'ls-ico-chart-bar-up', href: revenues_path(current_user.id))
        load_revenues
        render :revenues
      end
    end
  end

  def destroy
    entry = find_entry
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

  def invalid_currency_format
    flash.now[:alert] = 'O valor informado possui formato inválido ou está vazio. Verifique e tente novamente'
    if params.key? :entry_expense
      build_expense_from_params.validate
      load_expenses
      intro(message: 'Despesas', ico_class: 'ls-ico-cart', href: expenses_path(current_user.id))
      render :expenses
    else
      build_revenue_from_params.validate
      load_revenues
      intro(message: 'Receitas', ico_class: 'ls-ico-chart-bar-up', href: revenues_path(current_user.id))
      render :revenues
    end
  end

  def load_expenses
    @entries = Entry::Expense.where(user_id: current_user.id).order(entry_date: :desc, created_at: :desc)
  end

  def load_revenues
    @entries = Entry::Revenue.where(user_id: current_user.id).order(entry_date: :desc, created_at: :desc)
  end

  def load_categories
    @categories = Category.ordered
  end

  def find_entry
    Entry.find_by(user_id: current_user.id, id: params[:id])
  end

  def validate_session!
    raise ExpiredSessionError if current_user.blank?
  end

  def new_entry(type)
    @entry = Entry.new(type: type)
  end

  def intro(message:, ico_class:, href:)
    @intro = { message: message, icoClass: ico_class, href: href }.to_json
  end

  def build_expense_from_params
    @entry = Entry::Expense.new(
      category_id: params.dig(:entry_expense, :category_id),
      description: params.dig(:entry_expense, :description),
      amount:      params.dig(:entry_expense, :currency),
      entry_date:  params.dig(:entry_expense, :entry_date),
    )
  end

  def build_revenue_from_params
    @entry = Entry::Revenue.new(
      category_id: params.dig(:entry_revenue, :category_id),
      description: params.dig(:entry_revenue, :description),
      amount:      params.dig(:entry_revenue, :currency),
      entry_date:  params.dig(:entry_revenue, :entry_date),
    )
  end

  def entry_params
    key = params.key?(:entry_expense) ? :entry_expense : :entry_revenue
    params.require(key)
      .permit(:category_id, :description, :entry_date, :type)
      .merge(user_id: params[:user_id] || current_user.id)
      .merge(amount: parse_amount(params.dig(key, :currency)))
  end

  def parse_amount(input)
    BigDecimal(input.gsub('.', '').gsub(',', '.')).to_f
  rescue
    raise InvalidCurrencyFormat
  end
end
