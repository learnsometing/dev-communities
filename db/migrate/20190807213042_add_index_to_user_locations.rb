class AddIndexToUserLocations < ActiveRecord::Migration[5.2]
  def change
    add_index :user_locations, %i[user_id location_id], unique: true, name: 'user_by_location'
  end
end
