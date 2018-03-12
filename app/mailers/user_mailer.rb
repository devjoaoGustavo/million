# frozen_string_literal: true

class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url  = confirmation_url(@user.id)
    mail(to: @user.email, subject: 'Bem-vind@ ao Million!')
  end

  def recover_email(user)
    @user = user
    @url  = redefine_password_url(@user.id)
    mail(to: @user.email, subject: 'Redefina sua senha Million!')
  end
end
