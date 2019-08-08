class AddUniquenessToUserLocationIndices < ActiveRecord::Migration[5.2]
  def change
    remove_index :user_locations, :user_id
    add_index :user_locations, :user_id, unique: true
  end
end
