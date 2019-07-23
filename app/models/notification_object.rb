# frozen_string_literal: true

class NotificationObject < ApplicationRecord
  # Associations
  
  belongs_to :notification_triggerable, polymorphic: true
  has_many :notification_changes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  
  # Validations
  # validate :already_exists?, on: :create

  # Scopes

  scope :friend_request_type, -> { where(notification_triggerable_type: 'FriendRequest') }
  scope :triggerable_id_in_set, ->(ids) { where(notification_triggerable_id: ids) }
  
  def object
    # Retrieve the object that the notification object references.
    # Example: if the notification_triggerable_type is "Post" and
    # notification_triggerable_id is 1, this method will execute Post.find(1)
    notification_triggerable_type.constantize.find(notification_triggerable_id)
  end

  private

  # def already_exists?
  #   if NotificationObject.exists?(notification_triggerable_type: notification_triggerable_type,
  #                                 notification_triggerable_id: notification_triggerable_id)
  #     errors.add(:base, 'Notification object already exists.')
  #   end
  # end
end
