# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  before_action :logged_in_user

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
end
