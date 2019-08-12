# frozen_string_literal: true

class UsersController < ApplicationController
  # Helpers
  helper UsersHelper

  autocomplete :skill, :name, class_name: 'ActsAsTaggableOn::Tag', full: true
  # Before filters
  before_action :logged_in_user
  before_action :require_user_location
  before_action :require_skills, only: %i[show feed edit]
  before_action :correct_user, only: %i[edit update edit_skill_list]

  def show
    @user = User.find(params[:id])
    @skills = @user.tag_counts_on(:skills)
    @posts = @user.authored_posts
    @new_post = @user.posts.build if current_user?(@user)
    @friend_request = @user.sent_friend_requests.build
  end

  def feed
    @feed_items = current_user.feed
  end


  def friends
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    # Update the user model using the white-listed parameters. Works both for
    # updating profile picture and for updating skill list. The request referrer
    # is used to determing which flash message to display, or which action to
    # fall back to if the update fails.
    @user = User.find(params[:id])
    flash_messages, fallback_action = info_for_update(user_params)
    if @user.update(user_params)
      flash[:success] = flash_messages[:success]
      redirect_to @user
    else
      flash.now[:danger] = flash_messages[:failure]
      render fallback_action
    end
  end

  def edit_skill_list
    @user = User.find(params[:id])
  end

  def search
    @users = User.search(params[:term])
    render json: @users
  end

  private

  def user_params
    params.require(:user).permit(:profile_picture, skill_list: [])
  end

  def info_for_update(params)
    # Used in the update action to get the correct set of flash messages
    # and fallback action based on the key present in user_params. The user
    # will only be updating via one key at a time.
    if params.key?(:skill_list)
      [{ success: 'Your skills were successfully updated.',
         failure: "Your skills couldn't be updated." },
       'edit_skill_list']
    elsif params.key?(:profile_picture)
      [{ success: 'Your profile picture was successfully updated.',
         failure: "Your profile picture couldn't be updated." },
       'edit']
    end
  end

  # Before filters

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end
end
