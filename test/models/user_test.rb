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
end
