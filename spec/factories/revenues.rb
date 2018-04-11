# frozen_string_literal: true

FactoryBot.define do
  factory :revenue, class: Entry::Revenue do
    description 'Aquela dívida de uns anos atrás'
    amount      500.90
    entry_date  { Date.today }
    category_id { Category.find_or_create_by(
      name:        'Prestação de serviço',
      description: 'Recebimentos por prestação de serviços diversos'
    ).id }
  end
end
