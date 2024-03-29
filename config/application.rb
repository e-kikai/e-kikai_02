require File.expand_path('../boot', __FILE__)

require 'rails/all'

# require "charwidth"
# require "charwidth/string"
# require "charwidth/active_record"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EKikai
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    I18n.available_locales = I18n.available_locales.push(:ja)
    config.i18n.default_locale = :ja

    # config.active_job.queue_adapter = :sidekiq

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = { :host => 'localhost' }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address => Rails.application.secrets.mail_smtp_server,
      :port => 587,
      :user_name => Rails.application.secrets.mail_user_name,
      :password => Rails.application.secrets.mail_passwd,

      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end
end
