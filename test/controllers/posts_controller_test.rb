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

  test 'should redirect destroy when logged out' do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to new_user_session_path
  end
end
