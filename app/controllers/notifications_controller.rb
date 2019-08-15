# frozen_string_literal: true

# Allows the user to check their notifications and mark them as read by
# destroying them.
class NotificationsController < ApplicationController
  # Before filters
  before_action :logged_in_user
  before_action :require_user_location
  before_action :require_skills
  before_action :correct_notification, only: %i[destroy]

  def friend_request_notifications
    # Get the pending friend requests for the user to see
    request_ids = current_user.received_friend_requests.ids
    request_objects = NotificationObject.friend_request_type.triggerable_id_in_set(request_ids)
    @friend_request_notifications = Notification.with_objects(request_objects)
  end

  def index
    # Get all of the current user's unread notifications.
    notification_objects = current_user.notification_objects.except_friend_request_type
    @notifications = current_user.notifications.with_objects(notification_objects.ids)
  end

  def destroy
    Notification.find(params[:id]).destroy
    flash[:success] = 'Marked as read.'
    redirect_to notifications_path
  end

  private

  def correct_notification
    # Checks that the notification belongs to the currently logged in user to
    # prevent a malicious user from manipulating notifications that aren't theirs.
    redirect_to root_url if current_user.notifications.find_by(id: params[:id]).nil?
  end
end
