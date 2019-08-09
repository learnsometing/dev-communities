# frozen_string_literal: true

# The location model stores information about a place that can be looked up
# via google maps API. A location can have many users associated with it
# because many developers can live in the same location. The title of each
# Location must be unique, in order to distinguish between locations that
# may have the same name in different municipalities, states, etc.
class Location < ApplicationRecord
  # Associations
  has_many :user_locations, dependent: :destroy
  has_many :users, through: :user_locations

  # Validations
  validates :title, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validate :already_exists?, on: :create

  private

  def already_exists?
    if Location.exists?(title: title, latitude: latitude, longitude: longitude)
      errors.add(:base, 'This location already exists.')
    end
  end
end
