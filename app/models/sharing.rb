# frozen_string_literal: true

class Sharing < ApplicationRecord
  belongs_to :user
  belongs_to :wallet
end
