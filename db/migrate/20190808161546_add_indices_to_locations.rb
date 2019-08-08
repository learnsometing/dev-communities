class AddIndicesToLocations < ActiveRecord::Migration[5.2]
  def change
    add_index(:locations, :title, unique: true)
    add_index(:locations, :latitude)
    add_index(:locations, :longitude)
    add_index(:locations, %i[latitude longitude], unique: true)
  end
end
