# frozen_string_literal: true

class AddDescriptionToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :description, :string
  end
end
