# frozen_string_literal: true

class NotificationChange < ApplicationRecord
  belongs_to :notification_obj_ref
  belongs_to :actor, class_name: 'User'
end
