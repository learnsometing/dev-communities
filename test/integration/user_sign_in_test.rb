# frozen_string_literal: true

require 'test_helper'

class UserSignInTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @user.uid = '12345'
    @user.confirm
  end

  test 'existing user should be able to sign in' do
    get new_user_session_path
    assert_template 'users/sessions/new'
    post user_session_path, params: { user: { email: @user.email,
                                              password: @user.password } }
    assert user_logged_in?
  end

  test 'user should be able to sign in with their github credentials' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '12345'
    )

    get user_github_omniauth_authorize_path
    assert_redirected_to user_github_omniauth_callback_path
    assert user_logged_in?
  end
end
