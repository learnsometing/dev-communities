# frozen_string_literal: true

require 'test_helper'

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    users = []
    2.times do
      user = create(:confirmed_user_with_location_and_skills, location: @location)
      users << user
    end
    @friend = users[0]
    @requestor = users[1]
  end

  test 'should redirect all actions while logged out' do
    # create
    post friendships_path, params: { friend_request: { id: 1 } }
    assert_redirected_to new_user_session_path
    # index
    get friend_list_path(@requestor)
    assert_redirected_to new_user_session_path
    # destroy
    delete friendship_path(1)
    assert_redirected_to new_user_session_path
  end

  test "should redirect all actions if current user's location isn't set" do
    @requestor.update(user_location: nil)
    sign_in @requestor
    # create
    post friendships_path, params: { friend_request: { id: 1 } }
    assert_redirected_to new_user_location_path
    # index
    get friend_list_path(@requestor)
    assert_redirected_to new_user_location_path
    # destroy
    delete friendship_path(1)
    assert_redirected_to new_user_location_path
  end

  test "should redirect all actions if current user's skills aren't set" do
    @requestor.update(skill_list: nil)
    sign_in @requestor
    # create
    post friendships_path, params: { friend_request: { id: 1 } }
    assert_redirected_to edit_skill_list_path(@requestor.id)
    # index
    get friend_list_path(@requestor)
    assert_redirected_to edit_skill_list_path(@requestor.id)
    # destroy
    delete friendship_path(1)
    assert_redirected_to edit_skill_list_path(@requestor.id)
  end

  test "should redirect destroy if friendship doesn't belong to current user" do
    bad_guy = create(:confirmed_user_with_location_and_skills, location: @location)
    @requestor.friendships.create(friend_id: @friend.id)
    friendship = @requestor.friendships.first
    sign_in bad_guy
    assert_no_difference 'Friendship.count' do
      delete friendship_path(friendship.id)
    end
    assert_redirected_to root_url
  end
end
