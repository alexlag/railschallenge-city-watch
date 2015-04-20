ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'database_cleaner'
require 'simplecov'

SimpleCov.start

DatabaseCleaner.strategy = :truncation

module ActionDispatch
  class IntegrationTest
    def setup
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end
  end
end
