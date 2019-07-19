# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    author
    content { Faker::Lorem.paragraph(5) }
    created_at { Time.zone.now }
  end
end
