# frozen_string_literal: true

class Entry < ApplicationRecord
  include StringEnum

  belongs_to :wallet
  delegate :user_id, to: :wallet

  has_one :user, through: :wallet
  belongs_to :category, default: -> { Category.find_by(name: 'Categoria genérica') }

  # Relation for deal with installment entries
  # Useful when there are more than one entry to form an entire expense or revenue
  has_one :next_entry, class_name: self.name

  validate :validate_amount_format
  validates :type, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0.00 }


  scope :in_range, ->(wallet_id, range) do
    where(wallet_id: wallet_id, entry_date: range)
      .order(entry_date: :desc, created_at: :desc)
  end

  scope :by_wallet, ->(wallet_id) do
    where(wallet_id: wallet_id)
      .where('entry_date <= ?', Time.current.at_end_of_day)
      .order(entry_date: :desc, created_at: :desc)
  end

  string_enum type: %w{Entry::Revenue Entry::Expense}

  def validate_amount_format
    if amount.to_s.match("(([0-9]{1,3}[\.]*)*[0-9]{1,3}([\,][0-9]{1,2})*)").nil?
      errors.add(:amount, 'Fomato de data inválido')
    end
  end

  alias :expense? :'Entry::Expense?'
  alias :revenue? :'Entry::Revenue?'

  def currency
    sprintf("%.2f", amount).gsub('.', ',') if amount.present?
  end

  def self.total_balance(wallet_id)
    (Revenue.total_amount(wallet_id) - Expense.total_amount(wallet_id)).to_f
  end

  def self.total_amount(wallet_id)
    by_default_wallet(wallet_id).sum(&:amount)
  end

  def self.amount_by_category(wallet_id:, period:)
    in_range(wallet_id, period).group_by(&:category_id).map do |k, v|
      { category: Category.find(k).name, amount: v.sum(&:amount) }
    end
  end

  # Methods for deal with installment entries
  def next_entry?
    next_entry.present?
  end

  def installments?
    installments.count > 1
  end

  def installment_label
    return unless installments?
    sprintf("%d/%d", number, installments.count)
  end

  def previous_entry
    return if entry_id.blank?
    self.class.find_by(id: entry_id)
  end

  def entries_forward
    (Array(self) << next_entry&.entries_forward)
      .compact
      .flatten
  end

  def entries_backward
    Array(previous_entry)
      .unshift(previous_entry&.entries_backward)
      .compact
      .flatten
  end

  def number
    entries_backward.size + 1
  end

  def installments
    entries_backward + entries_forward
  end
end
