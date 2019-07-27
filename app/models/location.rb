# frozen_string_literal: true

class Location < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  def formatted_title
    return 'This user prefers to keep their location secret' if title == 'The Bermuda Triangle'

    title
  end
end
