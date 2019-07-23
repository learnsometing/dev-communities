require 'test_helper'

class FriendRequestNotificationsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @requestor = create(:confirmed_user)
    @friend = create(:confirmed_user)
    @requestor.sent_friend_requests.create(friend: @friend)
    @friend_request = @requestor.sent_friend_requests.first
    sign_in @friend
    get friend_request_notifications_path
  end

  test 'friend request notifications interface with successful accept' do
    assert_template 'notification_changes/friend_request_notifications'
    assert_select 'div.notification_description', count: 1
    assert_select 'div.accept_request_button', count: 1
    assert_select 'div.decline_request_button', count: 1
    assert_difference '@requestor.friendships.count', 1 do
      post friendships_path, params: { friend_request: { id: @friend_request.id } }
    end
    assert_not flash.empty?
    assert_redirected_to friend_request_notifications_path
    follow_redirect!
    assert_select 'div.alert-success', text: "You are now friends with #{@requestor.name}."
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
