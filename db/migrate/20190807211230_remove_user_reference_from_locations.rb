class RemoveUserReferenceFromLocations < ActiveRecord::Migration[5.2]
  def change
    remove_column(:locations, :user_id)
  end
end
