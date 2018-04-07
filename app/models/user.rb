class User < ApplicationRecord
  has_secure_password
  has_many :entries
  validates :email, :username, presence: true
  has_many :dreams, dependent: :destroy
  has_many :goals, through: :dreams

  validates_with UserValidator, fields: [:email]
  validate do |record|
    if record.password_confirmation.blank?
      record.errors.add(:password_confirmation, :blank) if record.new_record?
    end
  end

  def presentation_name
    name || username || email
  end

  def activate!
    return false unless self.persisted?
    self.active = true
    self.save
  end
end
