# frozen_string_literal: true

# A friendship links two friends together after a friend request is accepted.
# A friendship will be created on behalf of both the friend request 'requestor'
# and the 'friend' the request was sent to. This is facilitated by the creation
# of the reciprocal friendship on behalf of the friend after create is called
# on the initial friendship. Friendships were designed in this manner because
# any given user has friends through their friendships, so '.friends' can be
# called on a user to return the list of users they are in friendships with.

class Friendship < ApplicationRecord
  # Associations
  belongs_to :friend, class_name: 'User'
  has_many :notification_objects, as: :notification_triggerable, dependent: :destroy

  # Validations
  validate :unique_friendship?, on: :create

  # After filters
  after_create :create_reciprocal_friendship
  after_destroy :destroy_reciprocal_friendship

  private

  def unique_friendship?
    # Can't enforce uniqueness on user_id or friend_id alone, since a user can
    # have many friends. Thus, a custom validator is needed to check for unique
    # user_id and friend_id pairs.
    if Friendship.exists?(user_id: user_id, friend_id: friend_id)
      errors.add(:base, "You're already friends with this person.")
    end
  end

  def create_reciprocal_friendship
    # Called after create to create a reciprocal friendship on behalf of the
    # 'friend' that was sent the friend request.
    unless Friendship.exists?(friend_id: user_id, user_id: friend_id)
      send_friendship_notification
      Friendship.create(user_id: friend_id, friend_id: user_id)
    end
  end

  def destroy_reciprocal_friendship
    # Called after destroy to destroy a reciprocal friendship on behalf of the
    # friend that the current user was in a friendsip with.
    Friendship.find_by(user_id: friend_id).destroy if Friendship.exists?(user_id: friend_id)
  end

  def send_friendship_notification
    notification_object = notification_objects.create
    notification_change = notification_object.notification_changes.create(actor_id: friend_id)
    notification_object.notifications.create(user_id: user_id,
                                             description: notification_change.full_description)
  end
end
