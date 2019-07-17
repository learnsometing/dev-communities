# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  
  def logged_in_user
    unless user_signed_in?
      store_location
      flash[:danger] = 'You must be logged in to do that.'
      redirect_to new_user_session_path
    end
  end
end
