# frozen_string_literal: true

class Entry < ApplicationRecord
  include StringEnum

  belongs_to :user
  belongs_to :category
  has_many :entries_tags, class_name: EntryTag.to_s
  has_many :tags, through: :entries_tags

  validates :type, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0.00 }
  validate :validate_amount_format
  scope :in_range, ->(user_id, range) do
    where(user_id: user_id, entry_date: range)
      .order(entry_date: :desc, created_at: :desc)
  end
  scope :by_user, ->(user_id) do
    where(user_id: user_id).order(entry_date: :desc, created_at: :desc)
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

  def entry_date
    I18n.l(super, format: '%d/%m/%Y') if super.present?
  end

  def self.total_balance(user_id)
    (Revenue.total_amount(user_id) - Expense.total_amount(user_id)).to_f
  end

  def self.total_amount(user_id)
    by_user(user_id).sum(&:amount)
  end

  def self.amount_by_category(user_id:, period:)
    in_range(user_id, period).group_by(&:category_id).map do |k, v|
      { category: Category.find(k).name, amount: v.sum(&:amount) }
    end.to_json
  end
end
