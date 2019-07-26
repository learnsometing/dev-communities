require 'test_helper'

class FriendRequestNotificationsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    # Create the necessary users
    users = []
    3.times do
      user = create(:confirmed_user)
      users << user
    end

    @requestor  = users[0]
    @requestor2 = users[1]
    @friend     = users[2]
    
    # Send two friend requests to the same friend 
    @requestor.sent_friend_requests.create(friend: @friend)
    @requestor2.sent_friend_requests.create(friend: @friend)

    # Select the friend requests
    @friend_request = @requestor.sent_friend_requests.first
    @friend_request2 = @requestor2.sent_friend_requests.first

    sign_in @friend
    get friend_request_notifications_path
  end

  test 'friend request notifications interface with successful accept' do
    assert_template 'notifications/friend_request_notifications'
    assert_select 'div.notification_description', count: 2
    assert_select 'div.accept_request_button', count: 2
    assert_select 'div.decline_request_button', count: 2
    # Accept the request
    assert_difference '@requestor.friendships.count', 1 do
      post friendships_path, params: { friend_request: { id: @friend_request.id } }
    end
    assert_not flash.empty?
    assert_redirected_to friend_request_notifications_path
    follow_redirect!
    assert_select 'div.alert-success', text: "You are now friends with #{@requestor.name}."
    # Check that the FriendRequest default scope is working.
    assert_select 'div.notification_description', count: 1
    assert_select 'div.accept_request_button', count: 1
    assert_select 'div.decline_request_button', count: 1
  end

  test 'declined friend request' do
    assert_difference '@friend.received_friend_requests.count', -1 do
      delete friend_request_path(@friend_request)
    end
    assert_not flash.empty?
    assert_redirected_to friend_request_notifications_path
    follow_redirect!
    assert_select 'div.alert-notice', text: "Friend request successfully declined."
  end
end
