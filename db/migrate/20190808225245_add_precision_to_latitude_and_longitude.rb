class AddPrecisionToLatitudeAndLongitude < ActiveRecord::Migration[5.2]
  def change
    change_column(:locations, :latitude, :decimal, precision: 8, scale: 5)
    change_column(:locations, :longitude, :decimal, precision: 8, scale: 5)
  end
end
