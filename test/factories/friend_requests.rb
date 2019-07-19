# frozen_string_literal: true

FactoryBot.define do
  factory :friend_request do
    friend
    requestor
    after(:create) do
      create(:notification_obj_ref, notification_referable_id: id,
                                    notification_referable_type: 'FriendRequest')
    end
  end
end
