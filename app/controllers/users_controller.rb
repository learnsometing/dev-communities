# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  private

  def logged_in_user
    redirect_to new_user_registration_path unless user_signed_in?
  end
end
