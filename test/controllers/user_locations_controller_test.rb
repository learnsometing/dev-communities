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
    user_loc = create(:user_location, user: @user)
    get edit_user_location_path(user_loc)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update if logged out' do
    user_loc = create(:user_location, user: @user)
    patch user_location_path(user_loc), params: { location_id: 2 }
    assert_redirected_to new_user_session_path
  end

  test 'should redirect disable_location if logged out' do
    user_loc = create(:user_location, user: @user)
    patch disable_location_path(user_loc)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect new if the current user already has a location' do
    create(:user_location, user: @user)
    sign_in @user
    get new_user_location_path
    assert_redirected_to @user
  end

  test 'should redirect create if the current user already has a location' do
    sign_in @user
    create(:user_location, user: @user)
    assert_no_difference 'Location.count' do
      post user_locations_path, params: { location: attributes_for(:location) }
    end
    assert_redirected_to @user
  end

  test 'disable_location should trigger the disable action on the model' do
    sign_in @user
    create(:user_location, user: @user)
    patch disable_location_path(@user.user_location.id)
    @user.reload
    assert_nil @user.location
    assert_equal true, @user.user_location.disabled
  end

  test 'successful UserLocation creation with valid location' do
    sign_in @user
    assert_difference 'UserLocation.count', 1 do
      post user_locations_path, params: { location: attributes_for(:location) }
    end
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    @user.reload
    assert_select 'div.user-location', text: @user.location.title
    assert @user.location
  end

  test 'successful UserLocation creation with disabled location' do
    sign_in @user
    assert_difference 'UserLocation.count', 1 do
      post user_locations_path, params: { user_location: { location_id: nil } }
    end
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    @user.reload
    assert_select 'div.user-location', text: 'This user prefers to keep their location secret'
    assert @user.user_location
    assert @user.user_location.disabled
    assert_nil @user.user_location.location
  end

  test 'unsuccessful UserLocation creation with nil location' do
    sign_in @user
    existing_loc = create(:location)
    assert_no_difference 'UserLocation.count' do
      post user_locations_path, params: { location: { title: existing_loc.title,
                                                      latitude: 31,
                                                      longitude: 1 } }
    end
    assert_not flash.empty?
    assert_template 'user_locations/new'
    assert_select 'div.alert-danger'
  end

  test 'successful UserLocation update' do
    sign_in @user
    fred = create(:location, title: 'Fredericksburg, VA 22401, USA',
                             latitude: 37.3031837,
                             longitude: -77.46053990000001)
    stafford = create(:location, title: 'Stafford, VA 22554, USA',
                                 latitude: 38.4220687,
                                 longitude: -77.4083086)
    create(:user_location, user_id: @user.id, location_id: fred.id)
    patch user_location_path(@user.user_location), 
          params: { location: { title: stafford.title,
                                latitude: stafford.latitude,
                                longitude: stafford.longitude } }
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    assert_select 'div.alert-success'
    assert_match stafford.title, response.body
    @user.reload
    assert_equal stafford, @user.location
    assert fred.users.empty?
  end

  test 'unsuccessful UserLocation update' do
    sign_in @user
    fred = create(:location, title: 'Fredericksburg, VA 22401, USA',
                             latitude: 37.3031837,
                             longitude: -77.46053990000001)
    invalid_loc = { title: 'Fredericksburg, VA 22401, USA',
                    latitude: 38.4220687,
                    longitude: -77.4083086 }
    create(:user_location, user_id: @user.id, location_id: fred.id)
    patch user_location_path(@user.user_location), 
          params: { location: { title: invalid_loc[:title],
                                latitude: invalid_loc[:latitude],
                                longitude: invalid_loc[:longitude] } }
    assert_template 'user_locations/edit'
    assert_not flash.empty?
    assert_select 'div.alert-danger'
    @user.reload
    assert_equal fred, @user.location
  end

  test 'disable_location with successful update' do
    sign_in @user
    user_loc = create(:user_location, user_id: @user.id)
    patch disable_location_path(@user.user_location.id)
    @user.reload
    assert @user.user_location.disabled
    assert_nil @user.location
    patch user_location_path(@user.user_location.id),
          params: { location: { title: user_loc.location.title,
                                latitude: user_loc.location.latitude,
                                longitude: user_loc.location.longitude } }
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    assert_select 'div.alert-success'
    assert_match user_loc.location.title, response.body
    @user.reload
    assert_equal user_loc.location, @user.location
    assert_not @user.user_location.disabled
  end
end
