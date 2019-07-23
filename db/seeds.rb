# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

admin = User.new(name: 'Brian',
                 email: 'admin@foo.com',
                 password: 'foobar')

admin.skip_confirmation!
admin.save
admin.confirm

50.times do
  user = User.new(name: Faker::Name.name,
                  email: Faker::Internet.email,
                  password: 'foobar')
  user.skip_confirmation!
  user.save
  user.confirm
end

users_with_posts = User.take(5)

users_with_posts.each do |u|
  10.times do
    u.posts.create(content: Faker::Lorem.paragraph(10, true, 10))
  end
end

users_with_posts.each do |u|
  u.sent_friend_requests.create(friend: admin) unless u == admin
end
