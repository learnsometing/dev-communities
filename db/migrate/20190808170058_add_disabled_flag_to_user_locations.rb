class AddDisabledFlagToUserLocations < ActiveRecord::Migration[5.2]
  def change
    add_column(:user_locations, :disabled, :boolean, default: false)
    change_column_null(:user_locations, :user_id, false)
  end
end
