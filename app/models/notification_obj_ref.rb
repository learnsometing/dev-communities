# frozen_string_literal: true

class NotificationObjRef < ApplicationRecord
  # Associations

  belongs_to :notification_referable, polymorphic: true
  has_many :notification_changes
  has_many :notifications
  # Validations
  validate :already_exists?, on: :create

  def object
    notification_referable_type.constantize.find(notification_referable_id)
  end

  private

  def already_exists?
    if NotificationObjRef.exists?(notification_referable_type: notification_referable_type,
                                  notification_referable_id: notification_referable_id)
      errors.add(:base, 'Notification object already exists.')
    end
  end
end
