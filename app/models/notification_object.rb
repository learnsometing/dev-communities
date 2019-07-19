# frozen_string_literal: true

class NotificationObject < ApplicationRecord
  # Associations
  
  belongs_to :notification_triggerable, polymorphic: true
  has_many :notification_changes
  has_many :notifications
  
  # Validations
  validate :already_exists?, on: :create

  def object
    notification_triggerable_type.constantize.find()
  end

  private

  def already_exists?
    if NotificationObject.exists?(notification_triggerable_type: notification_triggerable_type,
                                  notification_triggerable_id: notification_triggerable_id)
      errors.add(:base, 'Notification object already exists.')
    end
  end
end
