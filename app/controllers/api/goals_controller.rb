# frozen_string_literal: true

module Api
  class GoalsController < ApplicationController
    def index
      render json: [{
        id:          '98ue98rcccc',
        title:       'Viagem para Rio Preto',
        description: 'Economizar para levar a Vanessa conosco pra RP',
        deadline:    '20/04/2018',
        amount:      'R$ 500,00',
        reached:     '35.65'
      },
      {
        id:          '9ru398rcccc',
        title:       'Lente 50mm Nikon',
        description: 'Economizar para comprar uma lente para a Vale',
        deadline:    '20/08/2018',
        amount:      'R$ 740,00',
        reached:     '0'
      },
      {
        id:          '98ue98r948j',
        title:       'Casamento',
        description: 'Economizar todo o dinheiro necessário para o casamento de Vale e João',
        deadline:    '27/04/2019',
        amount:      'R$ 20.000,00',
        reached:     '75.39'
      }], status: 200
    end
  end
end
