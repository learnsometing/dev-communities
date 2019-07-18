require 'test_helper'

class FriendRequestsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @friend = create(:user)
    @friend.confirm
    @requestor = create(:user)
    @requestor.confirm
    sign_in @requestor
  end

  test 'successful friend request and friend requests interface' do
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

  test 'cannot send a friend request while a pending request exists' do
    assert_difference 'FriendRequest.count', 1 do
      2.times do
        post friend_requests_path, params: { friend_request: 
                                             { requestor_id: @requestor.id,
                                               friend_id: @friend.id } }
      end
    end
    assert_not flash.empty?
    assert_redirected_to @friend
    follow_redirect!
    assert_select 'div.alert-danger', text: "You already friended this person."
  end
end

