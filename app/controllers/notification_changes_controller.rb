# frozen_string_literal: true

class NotificationChangesController < ApplicationController
  def friend_request_notifications
    friend_request_ids = current_user.notification_objects.friend_request_type.ids
    @friend_request_notifications = NotificationChange.where(notification_object_id: friend_request_ids)
  end
end
