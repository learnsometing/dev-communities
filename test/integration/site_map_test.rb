# frozen_string_literal: true

require 'test_helper'

class SiteMapTest < ActionDispatch::IntegrationTest
  test 'root route as logged out user' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', new_user_registration_path
  end

  test 'root route as signed in user' do
    user = create(:confirmed_user)
    sign_in user
    get root_path
    assert_redirected_to user_root_path
    follow_redirect!
    assert_template 'users/feed'
  end

  test 'sign up routing' do
    get new_user_registration_path
    assert_template 'users/registrations/new'
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: attributes_for(:user) }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_template 'users/mailer/confirmation_instructions'
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test 'sign in before confirmation' do
    user = create(:user)
    get new_user_session_path
    assert_template 'users/sessions/new'
    post user_session_path, params: { user: { email: user.email,
                                              password: user.password } }
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template 'users/sessions/new'
    assert_not flash.empty?
    assert_select 'div.alert-alert'
    assert_match 'You have to confirm your email address before continuing.', response.body
  end

  test 'sign in confirmed user without location set' do
    user = create(:confirmed_user_without_location)
    assert user.location.nil?
    assert user.valid?
    post user_session_path, params: { user: { email: user.email,
                                              password: user.password } }
    assert_redirected_to new_location_path
    follow_redirect!
    assert_template 'locations/new'
  end

  test 'sign in confirmed user with location set then sign out' do
    user = create(:confirmed_user_without_location)
    location = create(:location, title: 'Stafford, VA, 22554', latitude: 38.4150861,
                                 longitude: -77.4360554)
    user.create_user_location(location_id: location.id)
    assert user.valid?
    post user_session_path, params: { user: { email: user.email,
                                              password: user.password } }
    assert_redirected_to user_root_path
    follow_redirect!
    assert_template 'users/feed'

    # Log the user out to make sure they are directed to correct controller action
    delete destroy_user_session_path
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
  end
end
