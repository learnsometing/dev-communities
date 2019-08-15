# frozen_string_literal: true

require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:confirmed_user_with_location_and_skills)
    @post = @user.posts.create(content: 'This is my post.')
    sign_in(@user)
  end

  test 'post interface' do
    get user_path(@user)
    assert_select 'div.post-form'
  end

  test 'invalid post submission' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: '' } }
    end
    assert_redirected_to @user
    follow_redirect!
  end

  test 'valid post submission' do
    content = 'This is my first post.'
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content } }
    end
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_match content, response.body
  end

  test 'edit post interface' do
    get user_path(@user)
    assert_select "a#post-#{@post.id}-edit", text: 'Edit'
  end

  test 'valid post updates' do
    get edit_post_path(@post)
    assert_template 'posts/edit'
    og_content = @post.content
    patch post_path(@post), params: { post: { content: 'Edited' } }
    new_content = assigns(:post).content

    assert_not_equal og_content, new_content
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    assert_select 'div.alert-success'
    assert_match new_content, response.body
  end

  test 'invalid post updates' do
    get edit_post_path(@post)
    assert_template 'posts/edit'
    patch post_path(@post), params: { post: { content: '' } }
    assert_equal assigns(:post).errors.count, 1
    assert_template 'posts/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
    assert_select 'li', text: assigns(:post).errors.full_messages.first
  end

  test 'delete a post' do
    get user_path(@user.id)
    assert_select "a#post-#{@post.id}-delete", text: 'Delete'
    assert_difference 'Post.count', -1 do
      delete post_path(@post.id)
    end
  end
end
