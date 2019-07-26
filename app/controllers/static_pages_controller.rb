class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to user_root_path if current_user.confirmed_at
    else
      render 'static_pages/home'
    end
  end
end
