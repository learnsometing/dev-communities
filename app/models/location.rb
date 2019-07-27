# frozen_string_literal: true

class Location < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  def disable
    update(title: 'The Bermuda Triangle')
    update(latitude: 24.9999993)
    update(longitude: -71.0087548)
  end

  def disabled?
    return true if title == 'The Bermuda Triangle'

    false
  end

  def formatted_title
    return 'This user prefers to keep their location secret' if disabled?

    title
  end
end
