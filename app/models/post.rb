# frozen_string_literal: true

class Post < ApplicationRecord
  # Associations
  belongs_to :author, class_name: 'User'
  has_many :notification_objects, as: :notification_triggerable, dependent: :destroy

  # Validations
  validates :author_id, presence: true
  validates :content, presence: true, length: { maximum: 3000 }

  # Scopes

  # Always see newest posts first
  default_scope -> { order(created_at: :desc) }

  after_create :send_notifications

  private

  def send_notifications
    # Trigger the notification system after the creation of a post.
    return if author.friends.empty?
    
    if NotificationObject.exists?(notification_triggerable_id: id)
      notification_object = NotificationObject.find(notification_triggerable_id: id)
    else
      notification_object = notification_objects.create 
    end
    
    notification_change = notification_object.notification_changes.create(actor_id: author_id)
    author.friends.each do |friend|
      notification_object.notifications.create(user_id: friend.id,
                                               description: notification_change.full_description)
    end
  end
end
