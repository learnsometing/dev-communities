# frozen_string_literal: true

class UsersController < ApplicationController
  # Helpers
  helper UsersHelper

  autocomplete :skill, :name, class_name: 'ActsAsTaggableOn::Tag', full: true

  # Before filters
  before_action :logged_in_user
  before_action :location_set?
  before_action :correct_user, only: %i[edit update]

  def show
    @user = User.find(params[:id])
    @posts = @user.authored_posts
    @new_post = @user.posts.build if current_user?(@user)
    @friend_request = @user.sent_friend_requests.build
  end

  def feed
    @feed_items = current_user.feed
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = 'Profile Picture Updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit_skill_list
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:profile_picture, :skill_list)
  end

  # Before filters

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end
end
