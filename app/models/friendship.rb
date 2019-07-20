# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :friend, class_name: 'User'
  belongs_to :user
end
