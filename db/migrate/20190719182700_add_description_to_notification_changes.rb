class AddDescriptionToNotificationChanges < ActiveRecord::Migration[5.2]
  def change
    add_column :notification_changes, :description, :string
  end
end
