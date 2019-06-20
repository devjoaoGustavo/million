# frozen_string_literal: true

class Category < ApplicationRecord
  scope :ordered, -> { all.order(:name) }
end
