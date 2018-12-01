# frozen_string_literal: true

FactoryBot.define do
  factory :entry_base, class: Entry do
    transient do
      category     { 'Geral' }
      sub_category { 'Categoria genérica' }
    end

    description { 'Aquela dívida de uns anos atrás' }
    amount      { 500.90 }
    made_at     { Date.today }

    after(:create) do |re, ev|
      re.sub_category_id { SubCategory.find_or_create_by( name: ev.sub_category, category: Category.find_or_create_by(name: ev.category)).id }
    end

    trait :revenue do
      type { Entry::Revenue.to_s }
    end

    trait :expense do
      type { Entry::Expense.to_s }
    end

    factory :revenue, traits: %i(revenue)
    factory :expense, traits: %i(expense)
  end
end
