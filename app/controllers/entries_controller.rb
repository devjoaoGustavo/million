# frozen_string_literal: true

class EntriesController < ApplicationController
  include Timing
  before_action :validate_session!
  before_action :new_expense, except: :show
  before_action :new_revenue, except: :show
  before_action :load_categories, except: :show
  before_action :load_wallets, except: :show
  before_action :assign_dashboard_values, only: %i[index create]
  rescue_from InvalidCurrencyFormat, with: :invalid_currency_format

  def encrypt
    render layout: false
  end

  def new
    @entry = (params[:type] == 'expense' ? @new_expense : @new_revenue).tap do |entry|
      entry.entry_date = Time.zone.today
    end
  end

  def index
  end

  def search
    @goals = current_user.goals
    new_entry(params.slice(:type))
    filters = {}.tap do |f|
      f[:category_id] = params[:category_id] if params[:category_id].present?
      f[:entry_date]  = search_range
    end
    @entries = Entry.where(wallet_id: current_user.default_wallet.id, type: params[:type], **filters)
      .order(entry_date: :desc, created_at: :desc)

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
    @entries = WalletDecorator
      .decorate_collection(current_user.wallets_and_sharings)
      .sum(&:expenses_till_now)
      .sort_by(&:entry_date)
      .reverse

    render template: 'entries/expenses/index'
  end

  def revenues
    @entries = WalletDecorator
      .decorate_collection(current_user.wallets_and_sharings)
      .sum(&:revenues_till_now)
    render template: 'entries/revenues/index'
  end

  def show
    @entry = find_entry
  end

  def installments
    entry    = find_entry
    @entries = entry.installments
    intro(message:   'Parcelas de ' + entry.description,
          ico_class: (entry.expense? ? 'ls-ico-cart' : 'ls-ico-bar-up'),
          href:      (entry.expense? ? expenses_path(current_user.id) : revenues_path(current_user.id)))
  end

  def edit
    @entry = find_entry.object
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
      redirect_to dashboard_path(current_user.id)
    else
      flash[:alert] = 'A entrada não foi salva. Verifique os valores e tente novamente'
      render :index
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

  def assign_dashboard_values
    @balance = current_user.balance
    @expense = current_user.monthly_expense
    @revenue = current_user.monthly_revenue
    @monthly_balance = current_user.monthly_balance
    @entry = new_entry(entry_date: Time.zone.today)
  end

  def invalid_currency_format
    flash.now[:alert] = 'O valor informado possui formato inválido ou está vazio. Verifique e tente novamente'
    if params.key? :entry_expense
      build_expense_from_params.validate
    else
      build_revenue_from_params.validate
    end
    render :index
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

  def load_wallets
    @wallets = current_user.wallets
    @sharings = SharingDecorator.decorate_collection current_user.sharings
  end

  def find_entry
    Entry
      .find(params[:id])
      .then(&EntryDecorator.method(:decorate))
  end

  def new_entry(args = {})
    @entry = new_expense(args)
  end

  def new_expense(args = {})
    @new_expense = current_user
      .default_wallet
      .entries
      .build(args.reverse_merge(type: Entry::Expense.to_s))
  end

  def new_revenue
    @new_revenue = current_user
      .default_wallet
      .entries
      .build(type: Entry::Revenue.to_s)
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

  def create_params
    required = params.key?(:entry_expense) ? :entry_expense : :entry_revenue

    params.require(required)
      .permit(:category_id, :description, :amount, :entry_date, :goal_id, :type, :wallet_id)
      .merge(installments: params[:installments])
  end

  def update_params
    key = params.key?(:entry_expense) ? :entry_expense : :entry_revenue
    params.require(key)
      .permit(:category_id, :description, :amount, :entry_date, :goal_id, :wallet_id)
      .merge(id: params[:id])
  end

  def destroy_params
    params.permit(:mode, :id, :wallet_id)
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
