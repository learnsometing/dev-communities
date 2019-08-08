# frozen_string_literal: true

require 'test_helper'

class NotificationChangeTest < ActiveSupport::TestCase
  def setup
    location = create(:location)
    users = []
    2.times do
      user = create(:confirmed_user_without_location)
      create(:user_location, user_id: user.id, location_id: location.id)
      users << user
    end

    @user = users[0]
    @friend = users[1]
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
