# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:author] do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
