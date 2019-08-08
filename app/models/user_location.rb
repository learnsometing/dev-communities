class UserLocation < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :location

  validates :user, uniqueness: true

  def disable
    location = Location.find_or_create_by(title: 'The Bermuda Triangle')
    update(location_id: location.id)
  end
end
