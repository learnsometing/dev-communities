# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  belongs_to :friend, class_name: 'User'
  belongs_to :requestor, class_name: 'User'
end
