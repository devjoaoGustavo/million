# frozen_string_literal: true

FactoryBot.define do
  factory :goal, class: Goal do
    title       'Viagem para Cancun'
    description 'Ativar o projeto mão de vaca pra tudo e conseguir a grana'
    deadline    { Date.today + 1.year }
    amount      7564.45
  end
end
