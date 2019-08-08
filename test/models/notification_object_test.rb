# frozen_string_literal: true

require 'test_helper'

class NotificationObjectTest < ActiveSupport::TestCase
  def setup
    location = create(:location)
    users = []
    2.times do
      user = create(:confirmed_user_without_location)
      create(:user_location, user_id: user.id, location_id: location.id)
      users << user
    end
    @friend = users[0]
    @user = users[1]
    @user.sent_friend_requests.create(friend: @friend)
    @notification_object = NotificationObject.first
  end

  test 'associated notification changes should be destroyed' do
    assert_difference 'NotificationChange.count', -1 do
      @notification_object.destroy
    end
  end

  test 'associated notifications should be destroyed' do
    assert_difference 'Notification.count', -1 do
      @notification_object.destroy
    end
  end

  test 'friend request type scope' do
    assert_equal NotificationObject.friend_request_type.first, @notification_object
  end

  test 'object method should retreive the correct object' do
    assert_equal @notification_object.object, FriendRequest.first
  end
end
