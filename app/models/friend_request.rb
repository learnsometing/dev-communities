# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  belongs_to :friend, class_name: 'User'
  belongs_to :requestor, class_name: 'User'

  validate :already_exists?, on: :create

  def already_exists?
    if FriendRequest.exists?(friend_id: friend_id, requestor_id: requestor_id)
      errors.add(:base, 'You already friended this person.')
    end
  end
end
