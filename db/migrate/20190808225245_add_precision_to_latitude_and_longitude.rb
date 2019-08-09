# frozen_string_literal: true

class AddPrecisionToLatitudeAndLongitude < ActiveRecord::Migration[5.2]
  def up
    change_column(:locations, :latitude, :decimal, precision: 8, scale: 5)
    change_column(:locations, :longitude, :decimal, precision: 8, scale: 5)
  end

  def down
    change_column(:locations, :latitude, :decimal)
    change_column(:locations, :longitude, :decimal)
  end
end
