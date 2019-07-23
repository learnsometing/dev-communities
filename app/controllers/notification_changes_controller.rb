# frozen_string_literal: true

class NotificationChangesController < ApplicationController
  before_action :logged_in_user, only: %i[friend_request_notifications]
  def friend_request_notifications
    # Get the pending friend requests for the user to see
    pending_friend_request_ids = current_user.received_friend_requests.where(accepted: false).ids
    notification_object_ids = NotificationObject.friend_request_type.where(notification_triggerable_id: pending_friend_request_ids).ids
    @friend_request_notifications = NotificationChange.where(notification_object_id: notification_object_ids)
  end
end
