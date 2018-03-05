# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :entries
  scope :ordered, -> { all.order(:name) }
end
