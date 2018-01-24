class User < ApplicationRecord
  has_secure_password

  def presentation_name
    name || username || email
  end
end
