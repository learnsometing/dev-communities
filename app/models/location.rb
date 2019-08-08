# frozen_string_literal: true

# The location model stores information about a place that can be looked up
# via google maps API. A location can have many users associated with it
# because many developers can live in the same location.
class Location < ApplicationRecord
  # Associations
  has_many :user_locations, dependent: :destroy
  has_many :users, through: :user_locations
  
  # Validations
  validates :title, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validate :already_exists?, on: :create

  def disabled?
    return true if title == 'The Bermuda Triangle'

    false
  end

  def formatted_title
    return 'This user prefers to keep their location secret' if disabled?

    title
  end

  private

  def already_exists?
    if Location.exists?(title: title, latitude: latitude, longitude: longitude)
      errors.add(:base, 'This location already exists.')
    end
  end
end
