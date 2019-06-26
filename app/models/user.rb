class User < ApplicationRecord
  has_many :entries
  has_many :wallets, dependent: :destroy
  validates :email, :username, presence: true
  validates :username, uniqueness: true
  has_many :dreams, dependent: :destroy
  has_many :goals, through: :dreams

  validates_with UserValidator, fields: [:email]

  def self.from_omniauth(access_token)
    where(email: access_token.info.email).first_or_initialize do |user|
      user.name = access_token.info.name
      user.username = access_token.info.first_name
      user.email = access_token.info.email
    end
  end

  def presentation_name
    name || username || email
  end

  def default_wallet
    wallets.find_or_create_by(default: true)
  end
end
