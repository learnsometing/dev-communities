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
    if resource.is_a?(User) && resource.user_location.nil?
      new_user_location_path
    else
      stored_location_for(resource) || signed_in_root_path(resource)
    end
  end

  def require_user_location
    # Require that the user set up their user_location before continuing.
    # Halts the request cycle if the current_user's user_location is nil.
    if user_signed_in?
      unless current_user.user_location
        flash[:notice] = 'You must set your location before continuing.'
        redirect_to new_user_location_path
      end
    end
  end

  def require_skills
    # Require that the user set their skills before continuing.
    # Halts the request cycle if the current_user's skill_list is empty.
    if user_signed_in?
      if current_user.skills.empty?
        flash[:notice] = 'You must set your skills before continuing.'
        redirect_to edit_skill_list_path(current_user)
      end
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:warning] = 'Resource not found.'
    stored_location_for(resource) || signed_in_root_path(resource)
  end
end
