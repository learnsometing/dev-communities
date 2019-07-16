# frozen_string_literal: true

require 'test_helper'

class UserRegistrationTest < ActionDispatch::IntegrationTest
  test 'should register new user with valid name' do
    get new_user_registration_path
    assert_template 'users/registrations/new'
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: attributes_for(:user) }
    end
    assert_not flash.empty?
  end
end
