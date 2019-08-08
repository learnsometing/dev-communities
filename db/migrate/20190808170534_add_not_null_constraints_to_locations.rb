class AddNotNullConstraintsToLocations < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:locations, :title, false)
    change_column_null(:locations, :latitude, false)
    change_column_null(:locations, :longitude, false)
  end
end
