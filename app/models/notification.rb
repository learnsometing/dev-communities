class Notification < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :notification_object

  # Validations
  validates :description, presence: true
end
