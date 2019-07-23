# frozen_string_literal: true

require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  def setup
    @requestor = create(:confirmed_user)
    @friend = create(:confirmed_user)
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


end
