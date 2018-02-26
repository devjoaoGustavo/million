# frozen_string_literal: true

class HomeController < ApplicationController
  def home
    soon = 'Em breve, o mais simple e eficiente gerenciador de finanças que você já usou.'
    welcome = 'Bem vindo ao Million! Seu gerenciador pessoal de finanças.'

    @welcome = {
      message: logged_in? ? soon : welcome
    }.to_json
  end
end
