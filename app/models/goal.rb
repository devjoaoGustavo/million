# frozen_string_literal: true

class Goal < ApplicationRecord
  include StringEnum
  has_many :expenses, class_name: Entry::Expense.to_s
  has_many :dreams, dependent: :destroy
  has_many :users, through: :dreams

  string_enum status: %w(active inactive reached)
end
