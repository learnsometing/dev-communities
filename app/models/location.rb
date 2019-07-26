# frozen_string_literal: true

class Location < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
end
