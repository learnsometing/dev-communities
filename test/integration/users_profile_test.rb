# frozen_string_literal: true

require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    location = create(:location)
    users = create_list(:confirmed_user_with_location_and_skills, 2, location: location)
    @user = users[0]
    @other_user = users[1]
    posts = create_list(:post, 5)
    @user.posts = posts
  end

  test 'current user profile layout' do
    sign_in @user
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'div.prof-pic'
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'img[src=?]', @user.profile_picture.profile.url
    assert_select 'div.location'
    assert_select 'a[href=?]', edit_user_location_path(@user.user_location)
    assert_select 'div.friend-request-btn', count: 0
    assert_select 'div.friend-removal-btn', count: 0
    assert_select 'div.friend-count'
    @user.posts.each do |post|
      assert_match post.content, response.body
    end
  end

  test 'user profile layout' do
    sign_in @user
    get user_path(@other_user)
    assert_select 'a[href=?]', edit_user_path(@user), count: 0
    assert_select 'img[src=?]', @user.profile_picture.profile.url
    assert_select 'div.location'
    assert_select 'a[href=?]', edit_user_location_path(@user.user_location), count: 0
    assert_select 'div.friend-request-btn'
    assert_select 'div.friend-removal-btn', count: 0
    assert_select 'div.friend-count', count: 0
  end

  test 'friend user profile layout' do
    @user.friendships.create(friend: @other_user)
    sign_in @user
    get user_path(@other_user)
    assert_select 'div.friend-request-btn', count: 0
    assert_select 'div.friend-removal-btn'
    assert_select 'div.friend-count'
  end
end
