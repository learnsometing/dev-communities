# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  # Associations
  belongs_to :friend, class_name: 'User'
  belongs_to :requestor, class_name: 'User'
  has_many :notification_obj_refs, as: :notification_referable

  # Validations
  validate :already_exists?, on: :create

  # After filters
  after_create :send_request_notification

  def already_exists?
    if FriendRequest.exists?(friend_id: friend_id, requestor_id: requestor_id)
      errors.add(:base, 'You already friended this person.')
    end
  end

  private

  def send_request_notification
    @object_reference = notification_obj_refs.create
    @object_reference.notification_changes.create(actor_id: requestor_id)
    @object_reference.notifications.create(user_id: friend_id)
  end
end
