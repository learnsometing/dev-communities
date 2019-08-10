# frozen_string_literal: true

require 'test_helper'

class RemoveFriendTest < ActionDispatch::IntegrationTest
  def setup
    location = create(:location)
    users = create_list(:confirmed_user_with_location_and_skills, 2, location: location)
    @user = users[0]
    @friend = users[1]

    @friendship = @user.friendships.create(friend_id: @friend.id)
  end

  test 'friend removal interface' do
    sign_in @user
    get user_path(@friend)
    assert_select 'li.friend_removal_btn'
    assert_difference '@user.friendships.count', -1 do
      delete friendship_path(@friendship)
    end
    assert_equal @friend.friendships.count, 0
    assert_not flash.empty?
    assert_redirected_to @friend
    follow_redirect!
    assert_select 'div.alert-success'
    assert_select 'li.friend_request_btn'
  end
end
