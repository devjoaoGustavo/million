# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :sub_categories

  scope :ordered, -> { all.order(:name) }
end
