# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = create(:user)
    @user.confirm
  end

  test 'should redirect show unless logged in' do
    get user_url(@user)
    assert_redirected_to new_user_registration_path
  end

  test 'should get show while logged in' do

    sign_in(@user)
    get user_url(@user)
    assert_response :success
  end
end
