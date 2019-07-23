require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:confirmed_user)
  end

  test 'should redirect friend_request_notifications while logged out' do
    get friend_request_notifications_path
    assert_redirected_to new_user_session_path
  end
end
