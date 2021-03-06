# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  include Timing
  delegate_all

  def balance
    @balance ||= WalletDecorator
      .decorate_collection(wallets_and_sharings)
      .sum(&:balance)
  end

  def monthly_expense
    expenses_of_this_month.sum(&:amount)
  end

  def monthly_revenue
    revenues_of_this_month.sum(&:amount)
  end

  def monthly_entries
    collection = entries_by_month
    colors = ['#f00', '#0f0', '#3465cc']
    [].tap do |result|
      ['Despesas', 'Receitas', 'Saldo'].each_with_index do |entry_type, idx|
        result << {
          name: entry_type,
          data: collection.map { |line| [line.first, line[idx+1]] }.to_h,
          color: colors[idx]
        }
      end
    end
  end

  def entries_by_month
    [].tap do |result|
      grouped = Entry.where(wallet_id: wallets_and_sharings.map(&:id), entry_date: this_year).order(entry_date: :asc).group_by(&method(:per_month))
      I18n.t('date')[:abbr_month_names].compact.each_with_index do |month, idx|
        values = grouped[idx + 1] || []
        revs = values.select(&:revenue?).sum(&:amount)
        exps = values.select(&:expense?).sum(&:amount)
        result << [month,
                   BigDecimal(exps.to_s).to_f,
                   BigDecimal(revs.to_s).to_f,
                   BigDecimal(revs - exps).to_f]
      end
    end
  end

  def monthly_balance
    @monthly_balance ||= monthly_revenue - monthly_expense
  end

  def expenses_of_this_month
    @expenses_of_this_month ||= expenses.select { |entry| entry.entry_date.in? this_month }
  end

  def revenues_of_this_month
    @revenues_of_this_month ||= revenues.select { |entry| entry.entry_date.in? this_month }
  end

  def balance_of_last_days(days)
    revenues_of_last_days(days).sum(&:amount) - expenses_of_last_days(days).sum(&:amount)
  end

  def expenses_of_last_days(days)
    expenses.where(entry_date: last_days(days))
  end

  def revenues_of_last_days(days)
    revenues.where(entry_date: last_days(days))
  end

  def balance_of_today
    revenues_of_today.sum(&:amount) - expenses_of_today.sum(&:amount)
  end

  def expenses_of_today
    expenses.where(entry_date: today)
  end

  def revenues_of_today
    revenues.where(entry_date: today)
  end

  def expenses
    @expenses ||= wallets_and_sharings
      .flat_map(&:entries)
      .select(&:expense?)
      .sort_by(&:entry_date)
      .reverse
  end

  def revenues
    @revenues ||= wallets_and_sharings
      .flat_map(&:entries)
      .select(&:revenue?)
  end

  def expenses_by_category
    @expenses_by_category ||= by_category(Entry::Expense)
  end

  def revenues_by_category
    @revenues_by_category ||= by_category(Entry::Revenue)
  end

  def by_category(klass)
    klass
      .amount_by_category(wallet_id: wallets_and_sharings.map(&:id), period: this_month)
      .map(&:values)
      .to_h
  end

  def wallets_and_sharings
    wallets + sharings.flat_map(&:wallet)
  end

  private

  def per_month(entry)
    entry.entry_date.month
  end
end
