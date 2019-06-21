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

    config.action_mailer.default_url_options = { host: ENV.fetch('APP_URL', 'http://lvh.me:3000') }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      port:      587,
      address:   'smtp.mailgun.org',
      password:  ENV.fetch('SMTP_PASSWORD', 'a4e5fdec3955fe513a856a8b48252e5c'),
      user_name: ENV.fetch('SMTP_USER_NAME', 'postmaster@sandbox35effa733de044e0aae9b287ea732d24.mailgun.org')
    }

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.test_framework :rspec
      g.factory_bot false
    end

    config.i18n.available_locales = 'pt-BR'
    config.i18n.default_locale = 'pt-BR'
    config.time_zone = 'Brasilia'

    config.serve_static_assets = true

    config.filter_parameters << :password
  end
end
