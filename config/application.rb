# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module W3Analytics
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework nil
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # TODO: Use Sidekiq or Faktory in future
    config.active_job.queue_adapter = ActiveJob::QueueAdapters::AsyncAdapter.new(
      min_threads: 1,
      max_threads: 2 * Concurrent.processor_count,
      idletime: 600.seconds
    )

    # http://lulalala.logdown.com/posts/5835445-rails-many-default-url-options
    # if Settings.url_options&.respond_to?(:to_h)
    #   Rails.application.routes.default_url_options = Settings.url_options.to_h
    #   config.default_url_options = Settings.url_options.to_h
    #   config.action_controller.default_url_options = Settings.url_options.to_h
    #   config.action_mailer.default_url_options = Settings.url_options.to_h
    # end

    if Settings.hosts.is_a? Array
      config.hosts.concat Settings.hosts
    end
  end
end
