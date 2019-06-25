# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  include Timing
  delegate_all

  def balance
    @balance ||= revenues_till_now.sum(&:amount) - expenses_till_now.sum(&:amount)
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
      grouped = Entry.where(wallet_id: default_wallet.id, entry_date: this_year).order(entry_date: :asc).group_by(&method(:per_month))
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

  def expenses_till_now
    @expenses_till_now ||= Entry::Expense
      .by_default_wallet(default_wallet.id)
      .order(entry_date: :desc)
  end

  def revenues_till_now
    @revenues_till_now ||= Entry::Revenue
      .by_default_wallet(default_wallet.id)
      .order(entry_date: :desc)
  end

  def expenses_of_this_month
    @expenses_of_this_month ||= expenses.where(entry_date: this_month)
  end

  def revenues_of_this_month
    @revenues_of_this_month ||= revenues.where(entry_date: this_month)
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
    @expenses ||= default_wallet.entries
      .where(type: Entry::Expense.to_s)
      .order(entry_date: :desc)
  end

  def revenues
    @revenues ||= default_wallet.entries.where(type: Entry::Revenue.to_s)
  end

  def expenses_by_category
    @expenses_by_category ||= by_category(Entry::Expense)
  end

  def revenues_by_category
    @revenues_by_category ||= by_category(Entry::Revenue)
  end

  def by_category(klass)
    klass
      .amount_by_category(wallet_id: default_wallet.id, period: this_month)
      .map(&:values)
      .to_h
  end

  private

  def per_month(entry)
    entry.entry_date.month
  end
end
