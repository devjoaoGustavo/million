class User < ApplicationRecord
  has_secure_password
  has_many :entries
  validates :email, presence: true

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
