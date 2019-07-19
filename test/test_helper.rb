# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
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
end
