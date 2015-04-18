require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CityWatch
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    # Custom responer models
    config.autoload_paths += Dir[Rails.root.join('app', 'models', 'responders')]
  end
end
