# frozen_string_literal: true

class HomeController < ApplicationController
  def home
    soon    = 'Este é o Million, o mais simples e eficiente gerenciador de finanças que você já usou.'
    welcome = 'Bem-vind@ ao Million! Seu gerenciador pessoal de finanças.'

    @intro = {
      message: logged_in? ? soon : welcome,
      icoClass: 'ls-ico-home'
    }.to_json
  end
end
