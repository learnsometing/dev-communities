# frozen_string_literal: true

class CreateNotificationObjects < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_objects do |t|
      t.references :notification_triggerable, polymorphic: true,
                                            index: { name: 'notification_trigger_data',
                                                     unique: true }

      t.timestamps
    end
  end
end
