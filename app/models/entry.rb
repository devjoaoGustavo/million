# frozen_string_literal: true

class Entry < ApplicationRecord
  include StringEnum

  belongs_to :user
  belongs_to :category
  has_many :entries_tags, class_name: EntryTag.to_s
  has_many :tags, through: :entries_tags

  validates :kind, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0.00 }
  validate :validate_amount_format

  string_enum kind: %w{revenue expense}

  def validate_amount_format
    if amount.to_s.match("(([0-9]{1,3}[\.]*)*[0-9]{1,3}([\,][0-9]{1,2})*)").nil?
      errors.add(:amount, 'Fomato de data inválido')
    end
  end
end
