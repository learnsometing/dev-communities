# frozen_string_literal: true

module FriendshipsHelper
  def already_friends?(user)
    return true if Friendship.exists?(user_id: current_user.id,
                                      friend_id: user.id)

    false
  end
end
