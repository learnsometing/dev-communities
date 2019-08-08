# The UserLocationsController allows a user to set and update their location.
# It is in charge of associating a User model with a Location model through the
# user_locations table.
class UserLocationsController < ApplicationController
  # Before filters
  before_action :logged_in_user
  before_action :location?, only: %i[new create]

  def new
    @location = Location.new
  end

  def create
    @location = Location.find_or_initialize_by(title: params[:location][:title],
                                               latitude: params[:location][:latitude],
                                               longitude: params[:location][:longitude])
    @user_location = UserLocation.new(user_id: current_user.id, location_id: @location.id)

    if @user_location.save
      flash[:success] = 'Location set successfully.'
      redirect_to current_user
    else
      flash.now[:danger] = 'Location could not be set.'
      render 'new'
    end
  end

  def edit
    @user_location = UserLocation.find(params[:id])
  end

  def update
    @user_location = UserLocation.find(params[:id])
    if @user_location.update_attributes(location_params)
      flash[:success] = 'Location updated successfully'
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def disable
    Location.find(params[:id]).disable
    flash[:success] = 'Location successfully disabled. You can enable it again at any time.'
    redirect_to current_user
  end

  private

  def user_location_params
    params.require(:user_location).permit(:location_id)
  end

  def location?
    if current_user.location
      flash[:danger] = 'You already set your location. Visit the edit page to change it.'
      redirect_to current_user
    end
  end
end
