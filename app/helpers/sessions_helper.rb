# frozen_string_literal: true

module SessionsHelper
  def current_user?(user)
    user == current_user
  end

  # Friendly forwarding

  # Redirect to the stored location or to the default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Store the URL trying to be accessed while not logged in
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
