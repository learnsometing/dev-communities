# frozen_string_literal: true

class LocationsController < ApplicationController

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
end
