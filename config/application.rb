require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Million
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_mailer.default_url_options = { host: ENV['APP_URL'] }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      port:      587,
      address:   'smtp.mailgun.org',
      password:  ENV['SMTP_PASSWORD'],
      user_name: ENV['SMTP_USER_NAME']
    }

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.i18n.available_locales = :'pt-BR'
    config.i18n.default_locale = :'pt-BR'
  end
end
