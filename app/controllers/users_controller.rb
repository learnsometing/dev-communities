# frozen_string_literal: true

class UsersController < ApplicationController
  # Helpers
  helper UsersHelper

  autocomplete :skill, :name, class_name: 'ActsAsTaggableOn::Tag', full: true

  # Before filters
  before_action :logged_in_user
  before_action :require_user_location
  before_action :require_skills, only: %i[show feed edit]
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
    if params[:user][:skill_list]
      @user.skill_list = params[:user][:skill_list].join(', ')
      if @user.save
        flash[:success] = 'Your skills were successfully updated.'
        redirect_to @user
      else
        render 'edit_skill_list'
      end
    elsif params[:user][:profile_picture]
      if @user.update_attributes(user_params)
        flash[:success] = 'Your profile picture was successfully updated.'
        redirect_to @user
      else
        render 'edit'
      end
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
