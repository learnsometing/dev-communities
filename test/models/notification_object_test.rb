# frozen_string_literal: true

require 'test_helper'

class NotificationObjectTest < ActiveSupport::TestCase
  def setup
    @user = create(:confirmed_user)
    @friend = create(:confirmed_user)
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
