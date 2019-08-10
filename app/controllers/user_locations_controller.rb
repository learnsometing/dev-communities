# The UserLocationsController allows a user to set and update their location.
# It is in charge of associating a User model with a Location model through the
# user_locations table.
class UserLocationsController < ApplicationController
  # Before filters
  before_action :logged_in_user
  before_action :require_nil_user_location, only: %i[new create]
  before_action :require_skills, only: %i[edit update disable_location]
  before_action :correct_user_location, only: %i[edit update disable_location]

  def new
    @location = Location.new
    @user_location = UserLocation.new
  end

  def create
    # Attempts to create a new UserLocation. If there is an error and the Location
    # cannot be found or created, the if block will be executed because
    # the location will be set as nil, but disabled will still be set to false,
    # which will never be possible under normal conditions. Also defaults to this
    # behavior if the record can't be saved.
    @user_location = new_user_location

    if (@user_location.location.nil? && !@user_location.disabled) || !@user_location.save
      flash.now[:danger] = "Location couldn't be set."
      render 'new'
    else
      flash[:success] = 'Location set successfully.'
      redirect_to current_user
    end
  end

  def edit
    @user_location = UserLocation.find(params[:id])
    @location = if @user_location.location.nil?
                  Location.find_or_create_by(title: 'United States',
                                             latitude: 37.09024,
                                             longitude: -95.71289)
                else
                  @user_location.location
                end
  end

  def update
    @user_location = UserLocation.find(params[:id])
    @location      = Location.find_or_create_by(location_params)
    if @user_location && @location.valid?
      @user_location.update(location: @location, disabled: false)
      flash[:success] = 'Location updated successfully.'
      redirect_to current_user
    else
      flash.now[:danger] = "Location couldn't be set."
      render 'edit'
    end
  end

  def disable_location
    # If the user does not want to show their location, they can opt to disable
    # it. This action calls the disable method on the associated UserLocation,
    # which sets location_id to nil and disabled to true.
    UserLocation.find(params[:id]).disable
    flash[:success] = 'Location successfully disabled. You can enable it again at any time.'
    redirect_to current_user
  end

  private

  def location_params
    params.require(:location).permit(:title, :latitude, :longitude)
  end

  def user_location_params
    params.require(:user_location).permit(:location_id)
  end

  def new_user_location
    # A UserLocation can be created in 2 ways.
    #
    # If the user opts out of location services, a nil location_id will be sent
    # present in user_location_params. The UserLocation will be created with a 
    # nil location_id and with disabled set to true.
    #
    # If no user_location_params are present, location data from google maps
    # will be present in location_params and a Location record will be either 
    # found or created. This location is used in the UserLocation.
    if params[:user_location]
      UserLocation.new(user_id: current_user.id, location: nil, disabled: true)
    elsif params[:location]
      @location = Location.find_or_create_by(title: params[:location][:title],
                                       latitude: params[:location][:latitude],
                                       longitude: params[:location][:longitude])
      UserLocation.new(user_id: current_user.id, location_id: @location.id)
    end
  end

  def require_nil_user_location
    # Prevent the user from attempting to create a second user_location
    # over the web. Checks for a user_location before proceeding to new 
    # or create. If the user_location is nil, the request cycle should
    # proceed normally. If user_location is not nil, then the user must
    # have already set up their location and is barred from accessing
    # the new or create actions.

    return unless current_user.user_location

    msg = 'You must visit the edit page to change your location.'
    flash[:danger] = msg
    redirect_to current_user
  end

  def correct_user_location
    # Checks that the user_location belongs to the current user to prevent
    # a malicious user from manipulating user_locaitons that are not theirs.
    user_loc = UserLocation.find_by(id: params[:id])
    redirect_to root_url unless current_user.user_location == user_loc
  end
end
