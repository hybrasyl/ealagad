require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups(:assets => %w(development test)))

Dotenv::Railtie.load

module Hybrasyl
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.load_defaults 5.1

    src_paths = [
      "#{config.root}/app/services"
    ]

    config.autoload_paths.push(*src_paths)
    config.eager_load_paths.push(*src_paths)

    config.encoding = 'utf-8'
  end
end
