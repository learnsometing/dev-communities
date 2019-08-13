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
    user.reload
    assert_not user.location.nil?
    assert_equal location, user.location
  end

  test 'disable should set location to nil and disabled to true' do
    @user_location.disable
    assert_nil @user_location.location_id
    assert_equal true, @user_location.disabled
  end

  test 'display_title returns the correct title' do
    location = @user_location.location
    assert_equal location.title, @user_location.display_title
    @user_location.disable
    @user_location.reload
    assert_equal "This user's location is secret", @user_location.display_title
  end

  test 'search_by_loc_title should return correct results' do
    loc = @user_location.location
    # Search with actual location title
    assert_equal 1, UserLocation.search_by_loc_title(loc.title).size
    assert_equal @user_location, UserLocation.search_by_loc_title(loc.title).first
    # Search with location title that doesn't exist (location titles in the
    # Factory will always be the name of a state)
    assert UserLocation.search_by_loc_title("The Moon").empty?
  end

  test 'Works with any input type' do
    # Input is always converted to string
    assert UserLocation.search_by_loc_title(1).empty?
    assert UserLocation.search_by_loc_title([1, 2, 3]).empty?
    assert UserLocation.search_by_loc_title(:test).empty?
  end
end
