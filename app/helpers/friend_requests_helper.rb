module FriendRequestsHelper
  def already_requested?(user)
    return true if user.received_friend_requests.find_by(requestor_id: current_user.id)

    return false
  end
end
