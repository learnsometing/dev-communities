# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  def create
    friend_request = FriendRequest.find(params[:friend_request][:id])
    @requestor = User.find(friend_request.requestor_id)
    @friend =    User.find(friend_request.friend_id)

    begin
      @requestor.friendships.create(friend: @friend)
      @friend.friendships.create(friend: @requestor)
      # Send a notification to the requestor here....
      friend_request.accept
    rescue ActiveRecord::RecordNotFound => e
      flash[:danger] = e.message
    end

    flash[:success] = "You are now friends with #{@requestor.name}."

    redirect_to friend_requests_path
  end

  def destroy;end
end
