source 'https://rubygems.org'
ruby '2.6.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails',        '~> 5.1.6'

gem 'jquery-rails'
gem 'pg',           '~> 0.18'
gem 'puma',         '~> 3.7'
gem 'sass-rails',   '~> 5.0'
gem 'therubyracer', platforms: :ruby
gem 'turbolinks',   '~> 5.1.0'
gem 'uglifier',     '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder',     '~> 2.5'
gem 'bcrypt',       '~> 3.1.7'
gem 'foreman'
gem 'sentry-raven'

gem 'chartkick'
gem 'client_side_validations'
gem 'draper'
gem 'groupdate'

group :development, :test do
  gem 'pry-byebug'
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.7'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen',      '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
