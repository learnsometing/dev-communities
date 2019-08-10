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

  # Move this into the notification model test file?
  test 'post creation notfications system' do
    location = create(:location)
    users = create_list(:confirmed_user_with_location_and_skills, 4, location: location)
    author = users[0]
    friends = users[1..3]

    # Form the friendships between the post author and other users
    friends.each do |friend|
      author.friendships.create(friend: friend)
      assert_equal 0, friend.notifications.count
    end

    # Create the post, triggering the notification system
    author.posts.create(attributes_for(:post))

    # Check that each friend received a notification about the post's creation
    friends.each do |friend|
      assert_equal 1, friend.notifications.count
    end

    post_objects = NotificationObject.post_type
    post_notifications = Notification.where(notification_object_id: post_objects)
    post_notification_changes = NotificationChange.where(notification_object_id: post_objects)
    assert_equal 3, post_notifications.count
    assert_equal 1, post_notification_changes.count
    assert_equal 1, post_objects.count
  end
end
