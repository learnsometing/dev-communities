# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    title { Faker::Address.state }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
