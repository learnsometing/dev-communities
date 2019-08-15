# frozen_string_literal: true

# Represents an action by a user (a post creation, friendship creation, etc.)
# that triggered the notifications system.
class NotificationChange < ApplicationRecord
  # Associations
  belongs_to :notification_object
  belongs_to :actor, class_name: 'User'

  # Validations
  validates :notification_object, presence: true
  validates :actor, presence: true

  # Return the description text of the notification change by combining the action
  # description and the actor name.

  def full_description
    actor.name + describe_action
  end

  private

  # Evaluate the type of the notification object referenced and return the
  # appropriate text to describe the action.

  def describe_action
    case notification_object.notification_triggerable_type
    when 'FriendRequest'
      ' sent you a friend request.'
    when 'Friendship'
      ' accepted your friend request.'
    when 'Post'
      ' posted something new.'
    end
  end
end
