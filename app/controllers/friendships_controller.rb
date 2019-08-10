# frozen_string_literal: true

class FriendshipsController < ApplicationController

  # Before filters
  before_action :logged_in_user
  before_action :require_user_location
  before_action :require_skills
  before_action :correct_friendship, only: %i[destroy
  ]
  def create
    friend_request = FriendRequest.find(params[:friend_request][:id])
    requestor = User.find(friend_request.requestor_id)
    friend = User.find(friend_request.friend_id)

    friendship = requestor.friendships.build(friend: friend)
    if friendship.save
      friend_request.destroy
      flash[:success] = "You are now friends with #{requestor.name}."
    else
      friendship.errors.full_messages.each do |msg|
        flash[:danger] = msg
      end
    end
    redirect_to friend_request_notifications_path
  end

  def index
    @friends = current_user.friends
  end

  def destroy
    if Friendship.exists?(params[:id])
      friendship = Friendship.find(params[:id])
      user = friendship.friend
      friendship.destroy
      flash[:success] = 'Friendship successfully ended.'
    else
      flash[:danger] = 'That friendship does not exist.'
    end

    redirect_to user
  end

  private

  def correct_friendship
    # Checks that the friendship belongs to the current user to
    # prevent a malicious user from manipulating frienships that aren't theirs.

    redirect_to root_url if current_user.friendships.find_by(id: params[:id]).nil?
  end
end
