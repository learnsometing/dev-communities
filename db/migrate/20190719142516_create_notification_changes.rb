# frozen_string_literal: true

class CreateNotificationChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_changes do |t|
      t.references :notification_obj_ref, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :notification_changes, %i[notification_obj_ref_id user_id],
              name: 'notification_change_data'
  end
end
