# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :logged_in_user, only: %i[friend_request_notifications index]
  def friend_request_notifications
    # Get the pending friend requests for the user to see
    pending_f_r_ids = current_user.received_friend_requests.ids
    request_objects = NotificationObject.friend_request_type.triggerable_id_in_set(pending_f_r_ids)
    @friend_request_notifications = Notification.with_objects(request_objects)
  end

  def index
    # Get all of the current user's unread notifications. We want to select the
    # NotificationChanges with actor_ids included in our friends, just in case
    # Friendships are destroyed before a notification is read.

    notification_changes = NotificationChange.where(actor: current_user.friend_ids)

    notification_object_ids = []
    notification_changes.each do |c|
      unless NotificationObject.friend_request_type.ids.include?(c.notification_object_id)
        notification_object_ids << c.notification_object_id
      end
    end

    @notifications = current_user.notifications.with_objects(notification_object_ids)
  end

  def mark_as_read
    if Notification.exists?(params[:notification][:id])
      Notification.find(params[:notification][:id]).destroy
    else
      flash[:danger] = 'Notification could not be read.'
    end
    redirect_to notifications_path
  end
end
