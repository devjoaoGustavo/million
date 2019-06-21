class User < ApplicationRecord
  # has_secure_password
  has_many :entries, dependent: :destroy
  validates :email, :username, presence: true
  validates :username, uniqueness: true
  has_many :dreams, dependent: :destroy
  has_many :goals, through: :dreams

  validates_with UserValidator, fields: [:email]

  def self.from_omniauth(access_token)
    where(email: access_token.info.email).first_or_initialize do |user|
      user.name = access_token.info.name
      user.email = access_token.info.email
    end
  end

  def presentation_name
    name || username || email
  end
end
