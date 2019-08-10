# frozen_string_literal: true

require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    users = []
    2.times do
      users << create(:confirmed_user_with_location_and_skills, location: @location)
    end
    @friend = users[0]
    @requestor = users[1]
  end

  test 'should redirect all actions when logged out' do
    # create
    post friend_requests_path, params: { friend_request: { friend_id: @friend.id,
                                                           requestor_id: @requestor.id } }
    assert_redirected_to new_user_session_path
    # destroy
    @request = @requestor.sent_friend_requests.create(friend: @friend)
    delete friend_request_path(@request)
    assert_redirected_to new_user_session_path
  end

  test "should redirect all actions if current user's location isn't set" do
    @requestor.update(user_location: nil)
    sign_in @requestor
    # create
    post friend_requests_path, params: { friend_request: { friend_id: @friend.id,
                                                           requestor_id: @requestor.id } }
    assert_redirected_to new_user_location_path
    # destroy
    @request = @requestor.sent_friend_requests.create(friend: @friend)
    delete friend_request_path(@request)
    assert_redirected_to new_user_location_path
  end

  test "should redirect all actions if current user's skill list isn't set" do
    @requestor.update(skill_list: [])
    sign_in @requestor
    # create
    post friend_requests_path, params: { friend_request: { friend_id: @friend.id,
                                                           requestor_id: @requestor.id } }
    assert_redirected_to edit_skill_list_path(@requestor.id)
    # destroy
    @request = @requestor.sent_friend_requests.create(friend: @friend)
    delete friend_request_path(@request)
    assert_redirected_to edit_skill_list_path(@requestor.id)
  end

  test "should redirect destroy if friend request doesn't belong to current user" do
    bad_guy = create(:confirmed_user_with_location_and_skills, location: @location)
    @requestor.sent_friend_requests.create(friend_id: @friend.id)
    request = @requestor.sent_friend_requests.first
    sign_in bad_guy
    assert_no_difference 'FriendRequest.count' do
      delete friend_request_path(request.id)
    end
    assert_redirected_to root_url
  end
end
