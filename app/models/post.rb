# frozen_string_literal: true

class Post < ApplicationRecord
  # Associations
  belongs_to :author, class_name: 'User'
  has_many :notification_objects, as: :notification_triggerable
  
  # Validations
  validates :author_id, presence: true
  validates :content, presence: true, length: { maximum: 3000 }

  # Scopes

  # Always see newest posts first
  default_scope -> { order(created_at: :desc) }

end
