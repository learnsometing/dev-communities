# frozen_string_literal: true

require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    location = create(:location)
    users = []
    2.times do
      user = create(:confirmed_user_without_location)
      create(:user_location, user_id: user.id, location_id: location.id)
      users << user
    end
    @friend = users[0]
    @requestor = users[1]
  end

  test 'should redirect create when logged out' do
    post friend_requests_path, params: { friend_request: { friend_id: @friend.id,
                                                           requestor_id: @requestor.id } }
    assert_redirected_to new_user_session_path
  end

  test 'should redirect destroy when logged out' do
    @request = @requestor.sent_friend_requests.create(friend: @friend)
    delete friend_request_path(@request)
    assert_redirected_to new_user_session_path
  end
end
