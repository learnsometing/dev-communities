# frozen_string_literal: true

require 'test_helper'

class NotificationChangeTest < ActiveSupport::TestCase
  def setup
    @user = create(:confirmed_user)
    @friend = create(:confirmed_user)
    @user.sent_friend_requests.create(friend: @friend)
    @notification_change = NotificationChange.first
  end

  test 'should require actor' do
    @notification_change.actor_id = nil
    assert @notification_change.invalid?
  end

  test 'should require notification object' do
    @notification_change.notification_object_id = nil
    assert @notification_change.invalid?
  end
end
