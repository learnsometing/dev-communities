class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notification_obj_ref
end
