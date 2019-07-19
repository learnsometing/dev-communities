# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :notification_object, foreign_key: true

      t.timestamps
    end

    add_index :notifications, %i[user_id notification_object_id],
              name: 'notification_data'
  end
end
