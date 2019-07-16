# frozen_string_literal: true

module UsersHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def profile_belongs_to_current_user(user)
    current_user == user
  end
end
