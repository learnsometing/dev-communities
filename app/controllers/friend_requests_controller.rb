# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  
  # Before Filters
  before_action :logged_in_user
  before_action :require_user_location
  before_action :require_skills
  before_action :correct_friend_request, only: %i[destroy]

  def create
    friend_id = params[:friend_request][:friend_id]
    @friend = User.find(friend_id)
    @sent_request = current_user.sent_friend_requests.build(friend_id: friend_id)

    if @sent_request.save
      flash[:success] = 'Friend request sent successfully.'
    else
      @sent_request.errors.full_messages.each do |msg|
        flash[:danger] = msg
      end
    end

    redirect_to user_path(friend_id)
  end

  def destroy
    friend_request = FriendRequest.find(params[:id])
    friend_request.delete
    flash[:notice] = "Friend request successfully declined."
    redirect_to friend_request_notifications_path
  end

  private

  def correct_friend_request
    # Checks that the friend request belongs to the currently logged in user to
    # prevent a malicious user from manipulating friend requests that aren't 
    # theirs.
    @request = FriendRequest.find_by(id: params[:id])

    unless current_user.sent_friend_requests.include?(@request) ||
           current_user.received_friend_requests.include?(@request)
      redirect_to root_url
    end
  end
end
