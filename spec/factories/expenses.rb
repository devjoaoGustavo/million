# frozen_string_literal: true

FactoryBot.define do
  factory :expense, class: Entry::Expense do
    description 'Compras no mercado'
    amount      34.37
    entry_date  { Date.today }
    goal_id     nil
    category_id { Category.find_or_create_by(
      name:        'Alimentação',
      description: 'Gastos com comida'
    ).id }
  end
end
