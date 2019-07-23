# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :logged_in_user
  def create
    friend_request = FriendRequest.find(params[:friend_request][:id])
    requestor = User.find(friend_request.requestor_id)
    friend = User.find(friend_request.friend_id)

    friendship = requestor.friendships.build(friend: friend)
    if friendship.save
      friend_request.destroy
      # Send a notification to the requestor here....
      flash[:success] = "You are now friends with #{requestor.name}."
    else
      friendship.errors.full_messages.each do |msg|
        flash[:danger] = msg
      end
    end
    redirect_to friend_request_notifications_path
  end

  def destroy
    if Friendship.exists?(params[:id])
      friendship = Friendship.find(params[:id])
      user = friendship.friend
      friendship.destroy
      # friend_request = FriendRequest.where(requestor_id: current_user,
      #                                      friend_id: user.id).or(
      #                                        FriendRequest.where(requestor_id: user.id,
      #                                                            friend_id: current_user.id)
      #                                      )
      # friend_request.
      flash[:success] = 'Friendship successfully ended.'
    else
      flash[:danger] = 'That friendship does not exist.'
    end

    redirect_to user
  end
end
