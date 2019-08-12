# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = build(:user)
  end

  test 'should not save User without name' do
    @user.name = nil
    assert @user.invalid?
  end

  test 'name should not be longer than 50 chars' do
    @user.name = 'a' * 51
    assert @user.invalid?
  end

  test 'should not save User without email' do
    @user.email = nil
    assert @user.invalid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user_at_foo.org foo@@bar.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = build(:user, email: @user.email)
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'should not save User without password' do
    @user.password = nil
    assert @user.invalid?
  end

  test 'password should not be longer than 128 characters' do
    @user.password = 'a' * 129
    assert @user.invalid?
  end

  test 'user should have a default profile picture' do
    assert_not @user.profile_picture.url.nil?
  end

  test 'associated posts should be destroyed' do
    @user.save
    @user.posts.create!(content: 'Delete me please')
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end

  test 'associated friend requests should be destroyed' do
    @user.save
    friend = create(:confirmed_user)
    @user.sent_friend_requests.create(friend: friend)

    assert_equal friend.received_friend_requests.count, 1

    assert_difference 'FriendRequest.count', -1 do
      @user.destroy
    end

    assert_equal friend.received_friend_requests.count, 0
  end

  test 'associated notifications should be destroyed' do
    @user.save
    friend = create(:confirmed_user)
    @user.sent_friend_requests.create(friend: friend)
    assert_difference 'friend.notifications.count', -1 do
      friend.destroy
    end
  end

  test 'associated notification_objects should be destroyed' do
    @user.save
    friend = create(:confirmed_user)
    @user.sent_friend_requests.create(friend: friend)
    assert_difference 'friend.notification_objects.count', -1 do
      friend.destroy
    end
  end

  test 'associated notification_changes should be destroyed' do
    @user.save
    friend = create(:confirmed_user)
    @user.sent_friend_requests.create(friend: friend)
    assert_difference '@user.notification_changes.count', -1 do
      @user.destroy
    end
  end

  test 'associated friendships should be destroyed' do
    @user.save
    friend = create(:confirmed_user)
    @user.friendships.create(friend: friend)
    assert_difference '@user.friendships.count', -1 do
      @user.destroy
    end
  end

  test 'feed should have the right posts' do
    # Create the users. Set the location explicitly to avoid conflicts
    # between locations.
    location = create(:location)
    users = create_list(:confirmed_user_with_location_and_skills, 3, location: location)

    # Create posts for each user
    users.each do |user|
      2.times do
        user.posts.create(attributes_for(:post))
      end
    end

    requestor = users[0]
    friend1 = users[1]
    friend2 = users[2]

    requestor.friendships.create(friend: friend1)
    requestor.friendships.create(friend: friend2)

    # current user's posts
    requestor.posts.each do |post|
      assert requestor.feed.include?(post)
    end

    # friend1's posts
    friend1.posts.each do |post|
      assert friend1.feed.include?(post)
    end
  end

  test 'associated location should be destroyed' do
    user = create(:confirmed_user_with_location)
    assert_difference 'UserLocation.count', -1 do
      user.destroy
    end
  end

  test 'search should return correct results' do
    location = create(:location)
    users = create_list(:confirmed_user_with_location_and_skills, 4, location: location)
    users[0].update(name: 'Brian Monaccio')
    users[1].update(name: 'Kai Johnson')
    users[2].update(name: 'Kyle Johnson')
    users[3].update(name: 'John Paschal')
    # Search by name
    assert_equal 3, User.search('John').size
    assert User.search('z').empty?
    # Search by location
    assert_equal 4, User.search(location.title).size
    assert User.search('Fredericksburg').empty?
    # Search by tags
    assert_equal 4, User.search('JavaScript').size
    assert User.search('Python').empty?
  end
end
