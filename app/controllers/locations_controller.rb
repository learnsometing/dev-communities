# frozen_string_literal: true

class LocationsController < ApplicationController

  # Before filters
  before_action :logged_in_user
  before_action :location?, only: %i[new create]

  def new
    @location = Location.new
  end

  def create
    @location = current_user.build_location(title: params[:location][:title],
                                            latitude: params[:location][:latitude],
                                            longitude: params[:location][:longitude])
    if @location.save
      flash[:success] = 'Location set successfully.'
      redirect_to current_user
    else
      flash.now[:danger] = 'Location could not be set.'
      render 'new'
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(location_params)
      flash[:success] = 'Location updated successfully'
      redirect_to current_user
    else
      render 'edit'
    end
  end

  private

  def location_params
    params.require(:location).permit(:title, :latitude, :longitude)
  end

  def location?
    if current_user.location
      flash[:danger] = 'You already set your location. Visit the edit page to change it.'
      redirect_to current_user 
    end
  end
end
