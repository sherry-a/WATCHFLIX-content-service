require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ContentService
  class Application < Rails::Application
    config.load_defaults 7.0
    config.active_storage.service= :amazon
    # config.active_storage.service_configurations={
    #   amazon: {
    #     service: 'S3',
    #     access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    #     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    #     region: ENV['AWS_REGION'],
    #     bucket: ENV['BUCKET_NAME']
    #   }
    # }
    config.api_only = true
  end
end
