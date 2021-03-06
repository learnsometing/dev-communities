# frozen_string_literal: true

require 'test_helper'

class FriendRequestsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    location = create(:location)
    users = create_list(:confirmed_user_with_location_and_skills, 2, location: location)
    @friend = users[0]
    @requestor = users[1]
    sign_in @requestor
  end

  test 'friend request button should not be present if viewing current user' do
    get user_path(@requestor)
    assert_select 'div.friend-request-btn', count: 0
  end

  test 'friend request interface with successfully sent friend request' do
    get user_path(@friend)
    assert_select 'div.friend-request-btn'
    assert_difference 'FriendRequest.count', 1 do
      post friend_requests_path, params: { friend_request:
                                           { requestor_id: @requestor.id,
                                             friend_id: @friend.id } }
    end
    assert_not flash.empty?
    assert_redirected_to @friend
    follow_redirect!
    assert_select 'div.alert-success'
    assert_select 'div.friend-request-btn', false
  end

  test 'friend request interface with unsuccessful friend request' do
    2.times do
      post friend_requests_path, params: { friend_request:
                                            { requestor_id: @requestor.id,
                                              friend_id: @friend.id } }
    end
    assert_not flash.empty?
    assert_redirected_to @friend
    follow_redirect!
    assert_select 'div.alert-danger'
    assert_match  "Unable to send friend request.", response.body
  end

  test 'friend request button should not be present if already friends' do
    @requestor.friendships.create(friend: @friend)
    get user_path(@friend)
    assert_select 'div.friend-request-btn', count: 0
  end
end
