# frozen_string_literal: true

FactoryBot.define do
  factory :friend_request do
    friend
    requestor
  end

  # after(:create) do
  #   create(:notification_object, notification_triggerable_type: 'FriendRequest',
  #                                notification_triggerable_id: self.id)
  # end
end
