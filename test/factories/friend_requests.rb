# frozen_string_literal: true

FactoryBot.define do
  factory :friend_request do
    friend
    requestor
  end
end
