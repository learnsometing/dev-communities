# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  def create
    friend_request = FriendRequest.find(params[:friend_request][:id])
    @requestor = User.find(friend_request.requestor_id)
    @friend = User.find(friend_request.friend_id)

    friendship = @requestor.friendships.build(friend: @friend)
    if friendship.save
      friend_request.accept
      # Send a notification to the requestor here....
      flash[:success] = "You are now friends with #{@requestor.name}."
    else
      friendship.errors.full_messages.each do |msg|
        flash[:danger] = msg
      end
    end
    redirect_to friend_request_notifications_path
  end

  def destroy; end
end
