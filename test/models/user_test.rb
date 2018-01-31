# coding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should require email' do
    user = User.new(name: 'João',
                    username: 'joao',
                    email: nil,
                    password: '123',
                    password_confirmation: '123')

    assert_not user.valid?, 'valid with a nil email'
  end

  test 'should require password' do
    user = User.new(name: 'João',
                    username: 'joao',
                    email: 'joao@joao.com',
                    password: nil,
                    password_confirmation: '123')

    assert_not user.valid?, 'valid with a nil password'
  end

  test 'should require password confirmation' do
    user = User.new(name: 'João',
                    username: 'joao',
                    email: 'joao@joao.com',
                    password: '123',
                    password_confirmation: nil)

    assert_not user.valid?, 'valid without a password confirmation'
  end

  test 'should match password with password confirmation' do
    user = User.new(name: 'João',
                    username: 'joao',
                    email: 'joao@joao.com',
                    password: '123',
                    password_confirmation: 'banana')

    assert_not user.valid?, 'valid with divergent password and password confirmation'
  end

  test 'should save user with all attributes but password plain text' do
    User.create!(
      name:                  'João',
      username:              'joao',
      email:                 'joao@joao.net',
      password:              '123',
      password_confirmation: '123'
    )
    user = User.find_by_username 'joao'

    assert_equal 'João',          user.name
    assert_equal 'joao',          user.username
    assert_equal 'joao@joao.net', user.email

    assert_nil     user.password
    assert_nil     user.password_confirmation
    assert_not_nil user.password_digest
  end

  test 'should return name as presentation name' do
    user = User.new(name: 'João', username: 'joao', email: 'joao@joao.com', password: '123', password_confirmation: '123')

    assert_equal 'João', user.presentation_name
  end

  test 'should return username as presentation name' do
    user = User.new(name: nil, username: 'joao', email: 'joao@joao.com', password: '123', password_confirmation: '123')

    assert_equal 'joao', user.presentation_name
  end

  test 'should return email as presentation name' do
    user = User.new(name: nil, username: nil, email: 'joao@joao.com', password: '123', password_confirmation: '123')

    assert_equal 'joao@joao.com', user.presentation_name
  end

  test 'should be inactive by default' do
    user = User.new

    assert_not user.active?
  end

  test 'should be able to be activated when persisted' do
    user = User.create(name: nil, username: nil, email: 'joao@joao.com', password: '123', password_confirmation: '123')

    assert user.activate!
  end

  test 'should not be able to be activated when non persisted' do
    user = User.new(name: nil, username: nil, email: 'joao@joao.com', password: '123', password_confirmation: '123')

    assert_not user.activate!
  end
end
