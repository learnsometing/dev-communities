# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = create(:confirmed_user)
    @other_user = create(:confirmed_user_with_location)
  end

  test 'should redirect show unless logged in' do
    get user_url(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect feed unless logged in' do
    get user_root_path(@user)
    assert_not flash.empty?
    assert assert_redirected_to new_user_session_path
  end

  test 'should redirect edit unless logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update unless logged in' do
    patch user_path(@user), params: { user: { profile_picture: 'pic.jpg' } }
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test 'should redirect edit_skill_list unless logged in' do
    get edit_skill_list_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_session_path
  end

  test "should redirect show if logged in user hasn't set their location" do
    sign_in(@user)
    get user_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_location_path
  end

  test "should redirect feed if logged in user hasn't set their location" do
    sign_in(@user)
    get user_root_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_location_path
  end

  test "should redirect edit if logged in user hasn't set their location" do
    sign_in(@user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_location_path
  end

  test "should redirect update if logged in user hasn't set their location" do
    sign_in(@user)
    patch user_path(@user), params: { user: { profile_picture: 'felt_cute.jpg' } }
    assert_not flash.empty?
    assert_redirected_to new_user_location_path
  end

  test "should redirect edit_skill_list if logged in user hasn't set their location" do
    sign_in(@user)
    get edit_skill_list_path(@user)
    assert_not flash.empty?
    assert_redirected_to new_user_location_path
  end

  test "should redirect show if logged in user hasn't set their skill list" do
    sign_in(@other_user)
    get user_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to edit_skill_list_path(@other_user)
  end

  test "should redirect feed if logged in user hasn't set their skill list" do
    sign_in(@other_user)
    get user_root_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to edit_skill_list_path(@other_user)
  end

  test "should redirect edit if logged in user hasn't set their skill list" do
    sign_in(@other_user)
    get edit_user_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to edit_skill_list_path(@other_user)
  end

  test 'should redirect edit when logged in as the wrong user' do
    @other_user.skill_list = 'Java, C++'
    @other_user.save
    sign_in(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as the wrong user' do
    @other_user.skill_list = 'Java, C++'
    @other_user.save
    sign_in(@other_user)
    patch user_path(@user), params: { user: { profile_picture: 'pic.jpg' } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end
