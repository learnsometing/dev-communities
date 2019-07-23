# frozen_string_literal: true

class RemoveDescriptionFromNotificationChange < ActiveRecord::Migration[5.2]
  def change
    remove_column :notification_changes, :description
  end
end
