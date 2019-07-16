# frozen_string_literal: true

class UsersController < ApplicationController
  helper UsersHelper
  before_action :logged_in_user, only: %i[show]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
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

  private

  def logged_in_user
    redirect_to new_user_registration_path unless user_signed_in?
  end

  def user_params
    params.require(:user).permit(:profile_picture)
  end
end
