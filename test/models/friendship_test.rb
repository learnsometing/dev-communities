# frozen_string_literal: true

require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  def setup
    location = create(:location)
    users = create_list(:confirmed_user_with_location_and_skills, 2, location: location)
    @friend = users[0]
    @requestor = users[1]
    @friendship = @requestor.friendships.build(friend: @friend)
  end

  test 'a reciprocal friendship should be created upon save' do
    assert_difference '@friend.friendships.count', 1 do
      @friendship.save
    end
  end

  test 'friendships should be unique for a given user' do
    @friendship.save
    duplicate_friendship = @friendship.dup
    assert_no_difference '@friend.friendships.count' do
     duplicate_friendship.save
    end

    assert_equal duplicate_friendship.errors.count, 1
  end

  test 'should send a notification telling the requestor that the friend accepted their request' do
    assert_difference '@requestor.notifications.count', 1 do
      @friendship.save
    end
    assert_equal 1, @friend.notification_changes.count
    assert_equal 1, @requestor.notification_objects.count
  end
end
