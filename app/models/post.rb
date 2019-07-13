class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  # Always see newest posts first
  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { maximum: 3000 }
end
