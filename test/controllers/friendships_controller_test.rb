# frozen_string_literal: true

require 'test_helper'

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
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

  test 'should redirect create while logged out' do
    post friendships_path, params: { friend_request: { id: 1 } }
    assert_redirected_to new_user_session_path
  end

  test 'should redirect destroy while logged out' do
    @friendship = @requestor.friendships.create(friend: @friend)
    delete friendship_path(@friendship)
    assert_redirected_to new_user_session_path
  end
end
