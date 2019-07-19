# frozen_string_literal: true

class CreateNotificationObjRefs < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_obj_refs do |t|
      t.references :notification_referable, polymorphic: true,
                                            index: { name: 'notification_obj_reference_type',
                                                     unique: true }

      t.timestamps
    end
  end
end
