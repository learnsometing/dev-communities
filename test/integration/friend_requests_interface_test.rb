# frozen_string_literal: true

require 'test_helper'

class FriendRequestsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @friend = create(:confirmed_user)
    @requestor = create(:confirmed_user)
    sign_in @requestor
  end

  test 'friend request interface with successfully sent friend request' do
    get user_path(@friend)
    assert_select 'li.friend_request_btn'
    assert_difference 'FriendRequest.count', 1 do
      post friend_requests_path, params: { friend_request:
                                           { requestor_id: @requestor.id,
                                             friend_id: @friend.id } }
    end
    assert_not flash.empty?
    assert_redirected_to @friend
    follow_redirect!
    assert_select 'div.alert-success'
    assert_select 'li.friend_request_btn', false
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
    assert_select 'div.alert-danger', text: 'You already friended this person.'
  end
end
