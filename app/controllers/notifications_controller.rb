# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :logged_in_user, only: %i[friend_request_notifications]
  def friend_request_notifications
    # Get the pending friend requests for the user to see
    pending_f_r_ids = current_user.received_friend_requests.ids
    f_r_notification_objs = NotificationObject.friend_request_type.triggerable_id_in_set(pending_f_r_ids)
    @friend_request_notifications = Notification.where(notification_object: f_r_notification_objs)
  end
end
