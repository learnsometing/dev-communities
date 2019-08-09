require 'test_helper'

class UserLocationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:confirmed_user_without_location)
  end

  test 'should redirect new if logged out' do
    get new_user_location_path
    assert_redirected_to new_user_session_path
  end

  test 'should redirect create if logged out' do
    assert_no_difference 'UserLocation.count' do
      post user_locations_path, params: { location: attributes_for(:location) }
    end
    assert_redirected_to new_user_session_path
  end

  test 'should redirect edit if logged out' do
    user_loc = create(:user_location, user: @user, location: create(:location))
    get edit_user_location_path(user_loc)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update if logged out' do
    user_loc = create(:user_location, user: @user, location: create(:location))
    patch user_location_path(user_loc), params: { location_id: 2 }
    assert_redirected_to new_user_session_path
  end

  test 'should redirect new if the current user already has a location' do
    create(:user_location, user: @user, location: create(:location))
    sign_in @user
    get new_user_location_path
    assert_redirected_to @user
  end

  test 'should redirect create if the current user already has a location' do
    sign_in @user
    create(:user_location, user: @user, location: create(:location))
    assert_no_difference 'Location.count' do
      post user_locations_path, params: { location: attributes_for(:location) }
    end
    assert_redirected_to @user
  end

  test 'disable should successfully trigger the disable action on the model' do
    sign_in @user
    create(:user_location, user: @user)
    patch disable_location_path(@user.user_location.id)
    @user.reload
    assert_nil @user.location
    assert_equal true, @user.user_location.disabled
  end
end
