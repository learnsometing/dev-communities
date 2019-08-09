# frozen_string_literal: true

require 'test_helper'

class UserLocationTest < ActiveSupport::TestCase
  def setup
    @user_location = create(:user_location)
  end

  test 'should be valid' do
    assert @user_location.valid?
  end

  test 'user_location should have a user' do
    @user_location.user = nil
    assert @user_location.invalid?
  end

  test 'user_location should have an optional location' do
    @user_location.location = nil
    assert @user_location.valid?
  end

  test 'only one user_location per user' do
    user = @user_location.user
    location = @user_location.location
    assert_no_difference 'UserLocation.count' do
      UserLocation.create(user_id: user.id, location_id: location.id)
    end
  end

  test 'disable should set location to nil and disabled to true' do
    @user_location.disable
    assert_nil @user_location.location_id
    assert_equal true, @user_location.disabled
  end
end
