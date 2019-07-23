# frozen_string_literal: true

require 'test_helper'

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @requestor = create(:confirmed_user)
    @friend = create(:confirmed_user)
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
