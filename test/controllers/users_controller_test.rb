# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = create(:user)
    @user.confirm
    @other_user = create(:user)
    @other_user.confirm
  end

  test 'should redirect show unless logged in' do
    get user_url(@user)
    assert_redirected_to new_user_session_path
  end

  test 'should get show while logged in' do
    sign_in(@user)
    get user_url(@user)
    assert_response :success
  end

  test 'should redirect edit unless logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end
  
  test 'should redirect edit when logged in as the wrong user' do
    sign_in(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update unless logged in' do
    patch user_path(@user), params: { user: { profile_picture: 'pic.jpg' } }
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update when logged in as the wrong user' do
    sign_in(@other_user)
    patch user_path(@user), params: { user: { profile_picture: 'pic.jpg' } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
