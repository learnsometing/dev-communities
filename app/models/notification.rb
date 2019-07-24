class Notification < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :notification_object

  # Validations
  validates :description, presence: true

  # Scopes
  scope :with_objects, ->(objects) { where(notification_object: objects) }
end
