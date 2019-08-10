# frozen_string_literal: true

require 'test_helper'

class NotificationChangeTest < ActiveSupport::TestCase
  def setup
    location = create(:location)
    users = create_list(:confirmed_user_with_location_and_skills, 2, location: location)
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
