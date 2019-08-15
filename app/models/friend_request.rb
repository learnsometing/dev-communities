# frozen_string_literal: true

# A friend request models the invitation one user will send to another to be
# added to their network. Friend requests trigger the notification system.
# A NotificationObject that references the FriendRequest record is created
# after the FriendRequest is saved. Then, the NotificationObject's associated
# records, NotificationChange and Notification are created. The requestor is the
# person that initiates the request and will be used as the actor in the
# NotificationChange. The friend is the person the request is sent to and the
# Notification references.

class FriendRequest < ApplicationRecord
  # Associations
  belongs_to :friend, class_name: 'User'
  belongs_to :requestor, class_name: 'User'
  has_many :notification_objects, as: :notification_triggerable, dependent: :destroy

  # Validations
  validates :friend, presence: true
  validates :requestor, presence: true
  validate :unique_friend_request?, on: :create

  # After filters
  after_create { |controller| controller.send_notification(requestor_id, friend_id) }

  # Scopes
  default_scope -> { where(accepted: false) }

  def unique_friend_request?
    # Since uniqueness of friend_id or requestor_id alone cannot be enforced,
    # a custom validator that checks for the uniqueness of the pair was needed.

    if FriendRequest.exists?(friend_id: friend_id, requestor_id: requestor_id)
      errors.add(:base, 'You already friended this person.')
    end
  end

  def accept
    update(accepted: true)
  end
end
