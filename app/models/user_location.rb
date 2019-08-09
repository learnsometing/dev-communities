# frozen_string_literal: true

# UserLocation is a through model that is used to associate a user and a location.
# It is allows multiple users to be associated with the same location
# and ensures that only one location will be created per place on google maps.
class UserLocation < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :location, optional: true

  validates :user, presence: true, uniqueness: true

  def disable
    update(location: nil, disabled: true)
  end

  def formatted_title
    return 'This user prefers to keep their location secret' if disabled

    location.title
  end
end
