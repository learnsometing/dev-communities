# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  # Associations
  belongs_to :friend, class_name: 'User'
  belongs_to :requestor, class_name: 'User'
  has_many :notification_objects, as: :notification_triggerable, dependent: :destroy

  # Validations
  validates :friend, presence: true
  validates :requestor, presence: true
  validate :already_exists?, on: :create

  # After filters
  after_create :send_request_notification

  def already_exists?
    if FriendRequest.exists?(friend_id: friend_id, requestor_id: requestor_id)
      errors.add(:base, 'You already friended this person.')
    end
  end

  def accept
    update(accepted: true)
  end

  private

  def send_request_notification
    @object = notification_objects.create
    @object.notification_changes.create(actor_id: requestor_id)
    @object.notifications.create(user_id: friend_id)
  end
end
