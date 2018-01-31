# frozen_string_literal: true

class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url = confirmation_url(@user.id)
    mail(to: @user.email, subject: 'Welcome to Million')
  end
end
