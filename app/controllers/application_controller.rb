# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # Helpers
  include ApplicationHelper
  
  def logged_in_user
    unless user_signed_in?
      url = request.original_url if request.get?
      store_location_for(:user, url)
      flash[:danger] = 'You must be logged in to do that.'
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.location.nil?
      new_user_location_path
    else
      stored_location_for(resource) || signed_in_root_path(resource)
    end
  end

  def location_set?
    if user_signed_in?
      redirect_to new_user_location_path unless current_user.user_location
    end
  end
end
