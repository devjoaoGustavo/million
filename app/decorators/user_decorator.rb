# frozen_string_litera: true

class UserDecorator < ApplicationDecorator
  include Timing
  delegate_all

  def balance
    @balance ||= revenues_till_now.sum(&:amount) - expenses_till_now.sum(&:amount)
  end

  def monthly_balance
    @monthly_balance ||= revenues_of_this_month.sum(&:amount) - expenses_of_this_month.sum(&:amount)
  end

  def expenses_till_now
    @expenses_till_now ||= Entry::Expense.by_user(id)
  end

  def revenues_till_now
    @revenues_till_now ||= Entry::Revenue.by_user(id)
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
    @expenses ||= entries.where(type: Entry::Expense.to_s)
  end

  def revenues
    @revenues ||= entries.where(type: Entry::Revenue.to_s)
  end

  def expenses_by_category
    @expenses_by_category ||= by_category(Entry::Expense)
  end

  def revenues_by_category
    @revenues_by_category ||= by_category(Entry::Revenue)
  end

  def by_category(klass)
    klass
      .amount_by_category(user_id: id, period: this_month)
      .map(&:values)
      .unshift(['Category', 'Amount'])
  end
end
