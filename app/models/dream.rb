# frozen_string_literal: true

class Dream < ApplicationRecord
  belongs_to :goal
  belongs_to :user
end
