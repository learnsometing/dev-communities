module FriendshipsHelper
  def already_friends?(user)
    return true if Friendship.exists?(friend_id: user.id)

    return false
  end
end
