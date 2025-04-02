# filepath: /home/ajay/rails-7-training-session/config/application.rb
require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
# require "active_record/railtie" # Comment out or remove this line
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Rails7TrainingSession
  class Application < Rails::Application
    config.load_defaults 7.1

    # Disable Active Record
    config.generators.orm :mongoid
  end
end