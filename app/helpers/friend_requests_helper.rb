# frozen_string_literal: true

module FriendRequestsHelper
  def already_requested?(user)
    return true if user.received_friend_requests.find_by(requestor_id: current_user.id)

    false
  end
end
