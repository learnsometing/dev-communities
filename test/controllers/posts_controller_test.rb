require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = create(:post)
  end

  test 'should redirect create when logged out' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: 'This is a fake post.' } }
    end
    assert_redirected_to new_user_session_path
  end

  test 'should redirect edit when logged out' do
    get edit_post_path(@post)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect destroy when logged out' do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to new_user_session_path
  end

  test 'should redirect edit for wrong post' do
    user = create(:user)
    user.confirm
    sign_in user

    get edit_post_path(@post)
    assert_redirected_to root_url
  end

  test 'should redirect update for wrong post' do
    user = create(:user)
    user.confirm
    sign_in user

    patch post_path(@post), params: { post: { content: 'edited' } }
    assert_redirected_to root_url
  end

  test 'should redirect destroy for wrong post' do
    user = create(:user)
    user.confirm
    sign_in user

    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end

    assert_redirected_to root_url
  end
end
