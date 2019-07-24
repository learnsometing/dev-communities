# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    # Create a post factory, which is already associated with a user factory
    # and contains content.
    @post = create(:post)
  end

  test 'post with content belonging to an author should be valid' do
    assert @post.valid?
  end

  test 'post should be invalid without content' do
    @post.content = nil
    assert @post.invalid?
  end

  test 'post content should be limited to 3000 characters' do
    @post.content = 'a' * 3000
    assert @post.valid?

    @post.content += 'a'
    assert @post.invalid?
  end

  test 'order should be most recent first' do
    create(:post, created_at: 5.minutes.ago)
    create(:post, created_at: 10.minutes.ago)
    create(:post, created_at: 15.minutes.ago)
    assert_equal @post, Post.first
  end

  test 'post creation notficiations system' do
    author = create(:confirmed_user)
    friends = [create(:confirmed_user),
               create(:confirmed_user),
               create(:confirmed_user)]
    author.friendships.create(friend: friends[0])
    author.friendships.create(friend: friends[1])
    author.friendships.create(friend: friends[2])

    assert_equal friends[0].notifications.count, 0
    assert_equal friends[1].notifications.count, 0
    assert_equal friends[2].notifications.count, 0

    assert_difference 'friends[0].notifications.count', 1 do
      author.posts.create(attributes_for(:post))
    end
    assert_equal friends[1].notifications.count, 1
    assert_equal friends[2].notifications.count, 1

    assert_equal 3, Notification.count
    assert_equal 1, NotificationChange.count
    assert_equal 1, NotificationObject.count
  end
end
