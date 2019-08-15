# frozen_string_literal: true

# Stores a reference to the id of the object that triggered the notifications
# system along with its type. Can be used to filter notifications by their
# type and to retrieve records referenced by notifications.
class NotificationObject < ApplicationRecord
  # Associations
  belongs_to :notification_triggerable, polymorphic: true
  has_many :notification_changes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Validations
  validate :unique_notification_object, on: :create

  # Scopes
  scope :friend_request_type, -> { where(notification_triggerable_type: 'FriendRequest') }
  scope :except_friend_request_type, -> { where.not(notification_triggerable_type: 'FriendRequest') }
  scope :triggerable_id_in_set, ->(ids) { where(notification_triggerable_id: ids) }

  def object
    # Retrieve the object that the notification object references.
    # Example: if the notification_triggerable_type is "Post" and
    # notification_triggerable_id is 1, this method will execute Post.find(1)
    notification_triggerable_type.constantize.find(notification_triggerable_id)
  end

  private

  def unique_notification_object
    if NotificationObject.exists?(notification_triggerable_type: notification_triggerable_type,
                                  notification_triggerable_id: notification_triggerable_id)
      errors.add(:base, 'Notification object already exists.')
    end
  end
end
