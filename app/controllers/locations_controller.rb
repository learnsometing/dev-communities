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

  def edit; end

  def update; end

  private

  def location?
    flash[:danger] = 'You already set your location. Visit the edit page to change it'
    redirect_to current_user if current_user.location
  end
end
