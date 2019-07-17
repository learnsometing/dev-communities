# frozen_string_literal: true

require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @user.confirm
    posts = create_list(:post, 5)
    @user.posts = posts
  end

  test 'profile layout' do
    sign_in @user
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'div.prof_pic'
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'img[src=?]', @user.profile_picture.profile.url
    @user.posts.each do |post|
      assert_match post.content, response.body
    end
  end
end
