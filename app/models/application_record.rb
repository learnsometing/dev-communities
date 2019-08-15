# frozen_string_literal: true

# Base class that all models inherit from.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def formatted_timestamp
    created_at.strftime('%B %e at %l:%M %P')
  end

  def send_notification(actor_id, user_id)
    # Trigger the notification system after the creation of a triggerable
    # model.
    notification_object = notification_objects.find_or_create_by(notification_triggerable_id: id,
                                                                 notification_triggerable_type: self.class.to_s)
    notification_change = notification_object.notification_changes.find_or_create_by(notification_object_id: notification_object.id,
                                                                                     actor_id: actor_id)
    notification_object.notifications.create(user_id: user_id,
                                             description: notification_change.full_description)
  end
end
