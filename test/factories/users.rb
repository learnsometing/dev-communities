# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[author friend requestor] do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    
    factory :confirmed_user do
      confirmed_at { Date.today }
    end
  end
end
