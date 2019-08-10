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

  test 'should redirect show when logged out' do
    get post_path(@post)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect edit when logged out' do
    get edit_post_path(@post)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update when logged out' do
    patch post_path(@post), params: { post: { content: 'New content' } }
    assert_redirected_to new_user_session_path
  end

  test 'should redirect destroy when logged out' do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to new_user_session_path
  end

  test "should redirect all actions if current user's location isn't set" do
    user = create(:confirmed_user)
    @post.update(author_id: user.id)
    sign_in user
    # Create
    post posts_path, params: { post: { content: 'New post' } }
    assert_redirected_to new_user_location_path
    # Show
    get post_path(@post.id)
    assert_redirected_to new_user_location_path
    # Edit
    get edit_post_path(@post.id)
    assert_redirected_to new_user_location_path
    # Update
    patch post_path(@post.id), params: { post: { content: 'New post' } }
    assert_redirected_to new_user_location_path
    # Destroy
    delete post_path(@post.id)
    assert_redirected_to new_user_location_path
  end

  test "should redirect all actions if current user's skill_list isn't set" do
    user = create(:confirmed_user_with_location)
    @post.update(author_id: user.id)
    sign_in user
    # Create
    post posts_path, params: { post: { content: 'New post' } }
    assert_redirected_to edit_skill_list_path(user.id)
    # Show
    get post_path(@post.id)
    assert_redirected_to edit_skill_list_path(user.id)
    # Edit
    get edit_post_path(@post.id)
    assert_redirected_to edit_skill_list_path(user.id)
    # Update
    patch post_path(@post.id), params: { post: { content: 'New post' } }
    assert_redirected_to edit_skill_list_path(user.id)
    # Destroy
    delete post_path(@post.id)
    assert_redirected_to edit_skill_list_path(user.id)
  end

  test 'should redirect edit for wrong post' do
    user = create(:confirmed_user_with_location_and_skills)
    sign_in user

    get edit_post_path(@post)
    assert_redirected_to root_url
  end

  test 'should redirect update for wrong post' do
    user = create(:confirmed_user_with_location_and_skills)
    sign_in user

    patch post_path(@post), params: { post: { content: 'edited' } }
    assert_redirected_to root_url
  end

  test 'should redirect destroy for wrong post' do
    user = create(:confirmed_user_with_location_and_skills)
    sign_in user

    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end

    assert_redirected_to root_url
  end
end
