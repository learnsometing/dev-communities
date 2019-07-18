class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.integer :friend_id
      t.integer :requestor_id

      t.timestamps
    end
    add_index :friend_requests, :friend_id
    add_index :friend_requests, :requestor_id
    add_index :friend_requests, %i[requestor_id friend_id], unique: true
  end
end
