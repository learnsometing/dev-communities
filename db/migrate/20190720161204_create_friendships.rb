# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :friend
      t.references :user
      t.timestamps
    end

    add_index :friendships, %i[user_id friend_id], unique: true
  end
end
