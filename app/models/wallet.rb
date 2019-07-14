class Wallet < ApplicationRecord
  belongs_to :user
  has_many :entries
  has_many :sharings
end
