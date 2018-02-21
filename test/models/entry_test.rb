require 'minitest/autorun'

class EntryTest < ActiveSupport::TestCase
  test 'should be valid with required attributes' do
    Category.create!(name: 'Mercado', description: 'Compras em mercados, feiras ou ambulantes')
    category_id = Category.find_by_name('Mercado').id
    User.create!(name: 'João', username: 'joao', email: 'joao@joao.net', password: '123', password_confirmation: '123')
    user_id = User.find_by_username('joao').id
    entry = Entry.new(user_id: user_id,
                      description: 'Compras da semana',
                      category_id: category_id,
                      kind: :expense,
                      amount: 110.43)
    assert entry.valid?
  end

  test 'should be invalid with empty user_id' do
    Category.create!(name: 'Mercado', description: 'Compras em mercados, feiras ou ambulantes')
    category_id = Category.find_by_name('Mercado').id
    entry = Entry.new(user_id: nil,
                      description: 'Compras da semana',
                      category_id: category_id,
                      kind: :expense,
                      amount: 110.43)
    assert_not entry.valid?
  end

  test 'should be invalid with empty category_id' do
    User.create!(name: 'João', username: 'joao', email: 'joao@joao.net', password: '123', password_confirmation: '123')
    user_id = User.find_by_username('joao').id
    entry = Entry.new(user_id: user_id,
                      description: 'Feira livre no condomínio',
                      category_id: nil,
                      kind: :expense,
                      amount: 110.43)
    assert_not entry.valid?
  end

  test 'should be valid with empty description' do
    Category.create!(name: 'Mercado', description: 'Compras em mercados, feiras ou ambulantes')
    category_id = Category.find_by_name('Mercado').id
    User.create!(name: 'João', username: 'joao', email: 'joao@joao.net', password: '123', password_confirmation: '123')
    user_id = User.find_by_username('joao').id
    entry = Entry.new(user_id: user_id,
                      description: nil,
                      category_id: category_id,
                      kind: :expense,
                      amount: 110.43)
    assert entry.valid?
  end

  test 'should be invalid with empty kind' do
    Category.create!(name: 'Mercado', description: 'Compras em mercados, feiras ou ambulantes')
    category_id = Category.find_by_name('Mercado').id
    User.create!(name: 'João', username: 'joao', email: 'joao@joao.net', password: '123', password_confirmation: '123')
    user_id = User.find_by_username('joao').id
    entry = Entry.new(user_id: user_id,
                      description: 'Compras da semana',
                      category_id: category_id,
                      kind: nil,
                      amount: 110.43)
    assert_not entry.valid?
  end

  test 'should be invalid with empty amount' do
    Category.create!(name: 'Mercado', description: 'Compras em mercados, feiras ou ambulantes')
    category_id = Category.find_by_name('Mercado').id
    User.create!(name: 'João', username: 'joao', email: 'joao@joao.net', password: '123', password_confirmation: '123')
    user_id = User.find_by_username('joao').id
    entry = Entry.new(user_id: user_id,
                      description: 'Compras da semana',
                      category_id: category_id,
                      kind: :expense,
                      amount: nil)
    assert_not entry.valid?
  end

  test 'should be invalid with negative amount' do
    Category.create!(name: 'Mercado', description: 'Compras em mercados, feiras ou ambulantes')
    category_id = Category.find_by_name('Mercado').id
    User.create!(name: 'João', username: 'joao', email: 'joao@joao.net', password: '123', password_confirmation: '123')
    user_id = User.find_by_username('joao').id
    entry = Entry.new(user_id: user_id,
                      description: 'Compras da semana',
                      category_id: category_id,
                      kind: :expense,
                      amount: -10.90)
    assert_not entry.valid?
  end

  test 'should be valid with kind revenue' do
    Category.create!(name: 'Salario', description: 'Salário do quinto dia útil')
    category_id = Category.find_by_name('Salario').id
    User.create!(name: 'João', username: 'joao', email: 'joao@joao.net', password: '123', password_confirmation: '123')
    user_id = User.find_by_username('joao').id
    entry = Entry.new(user_id: user_id,
                      description: 'Salário 5 dia util',
                      category_id: category_id,
                      kind: :revenue,
                      amount: 1023.34)
    assert entry.valid?
  end

  test 'should be invalid with strange kind' do
    Category.create!(name: 'Salario', description: 'Salário do quinto dia útil')
    category_id = Category.find_by_name('Salario').id
    User.create!(name: 'João', username: 'joao', email: 'joao@joao.net', password: '123', password_confirmation: '123')
    user_id = User.find_by_username('joao').id
    assert_raise(ArgumentError) do
      entry = Entry.new(user_id: user_id,
                        description: 'Salário 5 dia util',
                        category_id: category_id,
                        kind: :other,
                        amount: 1023.34)
    end
  end
end
