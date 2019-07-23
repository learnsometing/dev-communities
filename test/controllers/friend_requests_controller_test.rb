# frozen_string_literal: true

require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @friend = create(:confirmed_user)
    @requestor = create(:confirmed_user)
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
