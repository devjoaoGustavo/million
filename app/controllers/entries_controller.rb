# frozen_string_literal: true

class EntriesController < ApplicationController
  include Timing
  before_action :validate_session!, except: :encrypt
  before_action :load_expenses, only: [:expenses]
  before_action :load_revenues, only: [:revenues]
  before_action :load_categories, only: [:revenues, :expenses, :edit, :create, :update, :search]
  rescue_from InvalidCurrencyFormat, with: :invalid_currency_format

  def encrypt
    render layout: false
  end

  def index
    intro(message: 'Painel', ico_class: 'ls-ico-dashboard', href: root_path)
    user = UserDecorator.decorate(current_user)
    @options = { userid: current_user.id, token: form_authenticity_token }.to_json
    @color_class = css_color_class(user.balance.to_f)

    @seven_days_expense     = user.expenses_of_last_days(7).sum(&:amount).to_f
    @seven_days_revenue     = user.revenues_of_last_days(7).sum(&:amount).to_f
    @seven_days_balance     = @seven_days_revenue - @seven_days_expense
    @seven_days_color_class = css_color_class(@seven_days_balance)

    @today_expense     = user.expenses_of_today.sum(&:amount).to_f
    @today_revenue     = user.revenues_of_today.sum(&:amount).to_f
    @today_balance     = @today_revenue - @today_expense
    @today_color_class = css_color_class(@today_balance)

    @data_expense = user.expenses_by_category
    @data_revenue = user.revenues_by_category
  end

  def search
    @goals = current_user.goals
    new_entry(params[:type])
    filters = {}.tap do |f|
      f[:category_id] = params[:category_id] if params[:category_id].present?
      f[:made_at]  = search_range
    end
    @entries = Entry.where(user_id: current_user.id, type: params[:type], **filters)
      .order(made_at: :desc, created_at: :desc)

    if @entry.expense?
      intro(message: 'Despesas', ico_class: 'ls-ico-cart', href: dashboard_path(current_user.id))
      render :expenses
    else
      intro(message: 'Receitas', ico_class: 'ls-ico-chart-bar-up', href: dashboard_path(current_user.id))
      render :revenues
    end
  end

  def search_range
    (initial_date || (Time.current - 90.years))..(final_date || (Time.current.utc + 90.years))
  end

  def initial_date
    return if params[:date_from].blank?
    Time.parse(params[:date_from])
  end

  def final_date
    return if params[:date_to].blank?
    Time.parse(params[:date_to]).at_end_of_day.utc
  end

  def expenses
    @goals = current_user.goals
    new_entry('Entry::Expense')
    intro(message: 'Despesas', ico_class: 'ls-ico-cart', href: dashboard_path(current_user.id))
    render template: 'entries/expenses/index'
  end

  def revenues
    new_entry('Entry::Revenue')
    intro(message: 'Receitas', ico_class: 'ls-ico-chart-bar-up', href: dashboard_path(current_user.id))
    render template: 'entries/revenues/index'
  end

  def show
    @entry = find_entry
    intro(message:   'Detalhes de ' + (@entry.expense? ? 'despesa' : 'receita'),
          ico_class: (@entry.expense? ? 'ls-ico-cart' : 'ls-ico-bar-up'),
          href:      (@entry.expense? ? expenses_path(current_user.id) : revenues_path(current_user.id)))
  end

  def installments
    entry    = find_entry
    @entries = entry.installments
    intro(message:   'Parcelas de ' + entry.description,
          ico_class: (entry.expense? ? 'ls-ico-cart' : 'ls-ico-bar-up'),
          href:      (entry.expense? ? expenses_path(current_user.id) : revenues_path(current_user.id)))
  end

  def edit
    @goals = current_user.goals
    @entry = find_entry
    intro(message:   @entry.expense? ? 'Despesas' : 'Receitas',
          ico_class: @entry.expense? ? 'ls-ico-cart' : 'ls-ico-chart-bar-up',
          href:      entry_path(@entry.id))
  end

  def update
    @entry = updater.call(update_params)

    if @entry.errors.empty?
      flash[:notice] = (@entry.expense? ? 'despesa' : 'receita') + ' alterada com sucesso'
      redirect_to @entry
    else
      flash[:alert] = 'A entrada não foi alterada. Verifique os valores e tente novamente'
      render :edit
    end
  end

  def create
    @entry = creator.call(create_params)

    if @entry.persisted?
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
    entry = destroyer.call(destroy_params)

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
    @entries = Entry::Expense.by_user(current_user.id)
  end

  def load_revenues
    @entries = Entry::Revenue.by_user(current_user.id)
  end

  def load_categories
    @categories = Category.ordered
  end

  def find_entry
    Entry.find_by(user_id: current_user.id, id: params[:id])
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
      made_at:  params.dig(:entry_expense, :made_at),
    )
  end

  def build_revenue_from_params
    @entry = Entry::Revenue.new(
      category_id: params.dig(:entry_revenue, :category_id),
      description: params.dig(:entry_revenue, :description),
      amount:      params.dig(:entry_revenue, :currency),
      made_at:  params.dig(:entry_revenue, :made_at),
    )
  end

  def create_params
    key = params.key?(:entry_expense) ? :entry_expense : :entry_revenue
    params.require(key)
      .permit(:category_id, :description, :amount, :made_at, :type, :goal_id)
      .merge(user_id: current_user.id)
      .merge(installments: params[:installments])
  end

  def update_params
    key = params.key?(:entry_expense) ? :entry_expense : :entry_revenue
    params.require(key)
      .permit(:category_id, :description, :amount, :made_at, :goal_id)
      .merge(id: params[:id])
      .merge(user_id: current_user.id)
  end

  def destroy_params
    params.permit(:mode, :id).merge(user_id: current_user.id)
  end

  def css_color_class(amount)
    return 'ls-color-theme' if amount.zero?
    return 'ls-color-danger' if amount < 0.0
    'ls-color-success'
  end

  def creator
    Entry::Creator.new
  end

  def updater
    Entry::Updater.new
  end

  def destroyer
    Entry::Destroyer.new
  end
end
