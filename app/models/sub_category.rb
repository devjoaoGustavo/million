# frozen_string_literal: true

class SubCategory < ApplicationRecord
  has_many :entries
  belongs_to :category

  scope :ordered, -> { all.order(:name) }
end
