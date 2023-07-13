require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module ApexLegendsStatusApp
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.default_locale = :ja

    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag }
    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end
  end
end
