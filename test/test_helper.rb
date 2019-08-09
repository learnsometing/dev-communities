# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/minitest'
require 'fileutils'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  # Add more helper methods to be used by all tests here...
  def user_logged_in?
    !cookies['_dev_communities_session'].nil?
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # Make the Capybara DSL available in all integration tests
  # include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  # include Capybara::Minitest::Assertions

  # Reset sessions and driver between tests
  # teardown do
  #   Capybara.reset_sessions!
  #   Capybara.use_default_driver
  # end
end
