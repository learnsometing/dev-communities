# frozen_string_literal: true

class RenameUserIdToActorId < ActiveRecord::Migration[5.2]
  def change
    rename_column :notification_changes, :user_id, :actor_id
  end
end
