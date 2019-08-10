require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:confirmed_user_with_location_and_skills)
  end

  test 'should redirect all actions while logged out' do
    # friend_request_notifications
    get friend_request_notifications_path
    assert_redirected_to new_user_session_path
    # index
    get notifications_path
    assert_redirected_to new_user_session_path
    # mark_as_read
    get notifications_path(1)
    assert_redirected_to new_user_session_path
  end

  test "should redirect all actions if current user hasn't set their location" do
    @user.update(user_location: nil, skill_list: [])
    sign_in @user
    # friend_request_notifications
    get friend_request_notifications_path
    assert_redirected_to new_user_location_path
    # index
    get notifications_path
    assert_redirected_to new_user_location_path
    # mark_as_read
    get notifications_path(1)
    assert_redirected_to new_user_location_path
  end

  test "should redirect all actions if current user hasn't set their skills" do
    @user.update(skill_list: [])
    sign_in @user
    # friend_request_notifications
    get friend_request_notifications_path
    assert_redirected_to edit_skill_list_path(@user.id)
    # index
    get notifications_path
    assert_redirected_to edit_skill_list_path(@user.id)
    # mark_as_read
    get notifications_path(1)
    assert_redirected_to edit_skill_list_path(@user.id)
  end

  test "should redirect destroy if the notification doesn't belong to the current user" do
    other_user = create(:confirmed_user_with_location_and_skills, 
                        location: @user.location)
    # create a friend request so we generate a notification
    @user.sent_friend_requests.create(friend_id: other_user.id)
    other_user.reload
    notification = other_user.notifications.first
    sign_in @user
    assert_no_difference 'Notification.count' do
      delete notification_path(notification.id)
    end
  end
end
