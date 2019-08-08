# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[author friend requestor] do
    # An unconfirmed user that has just signed up for the site
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    
    factory :confirmed_user do
      # A confirmed user that has also set their location.
      # Only use in tests that require one user after confirmation with location 
      # set. Otherwise, creating multiple users may lead to conflicts with 
      # location, because creating a confirmed user also creates a location.
      # If the location exists, the database will throw an error.
      confirmed_at { Date.today }
      location
    end

    factory :confirmed_user_without_location do
      # A confirmed user that has not set their location. Use this factory
      # in tests that require multiple confirmed users.
      # Then set each user_location using the location factory.
      confirmed_at { Date.today }
    end      
  end
end
