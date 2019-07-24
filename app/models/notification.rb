class Notification < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :notification_object

  # Validations
  validates :description, presence: true

  # Scopes
  scope :with_objects, ->(objects) { where(notification_object: objects) }
  scope :unread, -> { where(read: false) }

  def mark_as_read
    update(read: true)
  end
end
