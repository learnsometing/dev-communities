# frozen_string_literal: true

# Used to create and destroy friend requests.
class FriendRequestsController < ApplicationController
  # Before Filters
  before_action :logged_in_user
  before_action :require_user_location
  before_action :require_skills
  before_action :correct_friend_request, only: %i[destroy]

  def create
    friend = User.find(params[:friend_request][:friend_id])
    friend_request = current_user.sent_friend_requests.build(friend_id: friend.id)

    if friend_request.save
      flash[:success] = 'Friend request sent successfully.'
    else
      flash[:danger] = "Couldn't send friend request."
    end

    redirect_to user_path(friend.id)
  end

  def destroy
    # Used to 'decline' a friend request by finding the received request and
    # destroying it. Could be modified to allow a user to cancel a sent
    # friend request.
    FriendRequest.find(params[:id]).delete
    flash[:notice] = 'Friend request successfully declined.'
    redirect_to friend_request_notifications_path
  end

  private

  def correct_friend_request
    # Prevent friend requests from being destroyed by users other than the user.
    # that received the request. Could be modified to check for the request in
    # a user's sent requests, in the case of cancelling a request.
    req = FriendRequest.find_by(id: params[:id])
    redirect_to root_url unless current_user.received_friend_requests.include?(req)
  end
end
