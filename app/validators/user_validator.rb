# frozen_string_literal: true

class UserValidator < ActiveModel::Validator
  def validate(record)
    unless record.email&.match?(/([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+/)
      record.errors[:email] << 'Formato de email inválido'
    end
  end
end

