# frozen_string_literal: true

# Is received by the user when the notifications system is triggered. References
# the object that triggers the notifications system.
class Notification < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :notification_object

  # Validations
  validates :description, presence: true

  # Scopes
  scope :with_objects, ->(objects) { where(notification_object: objects) }
end
