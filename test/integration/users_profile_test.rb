# frozen_string_literal: true

require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    location = create(:location)
    users = []
    2.times do
      user = create(:confirmed_user_without_location)
      create(:user_location, user_id: user.id, location_id: location.id)
      users << user
    end
    @user = users[0]
    @other_user = users[1]
    posts = create_list(:post, 5)
    @user.posts = posts
  end

  test 'current user profile layout' do
    sign_in @user
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'div.prof_pic'
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'img[src=?]', @user.profile_picture.profile.url
    assert_select 'div.location'
    assert_select 'a[href=?]', edit_user_location_path(@user.user_location)
    assert_select 'li.friend_request_button', count: 0
    assert_select 'li.friend_removal_button', count: 0
    assert_select 'li.friend-count'
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
    assert_select 'li.friend_request_btn'
    assert_select 'li.friend_removal_btn', count: 0
    assert_select 'li.friend-count', count: 0
  end

  test 'friend user profile layout' do
    @user.friendships.create(friend: @other_user)
    sign_in @user
    get user_path(@other_user)
    assert_select 'li.friend_request_btn', count: 0
    assert_select 'li.friend_removal_btn'
    assert_select 'li.friend-count'
  end
end
