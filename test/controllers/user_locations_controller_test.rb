require 'test_helper'

class UserLocationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:confirmed_user_with_location_and_skills)
    @user_location = @user.user_location
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
    get edit_user_location_path(@user_location)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update if logged out' do
    patch user_location_path(@user_location), params: { location_id: 2 }
    assert_redirected_to new_user_session_path
  end

  test 'should redirect disable_location if logged out' do
    patch disable_location_path(@user_location)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect new if the current user already has a location' do
    sign_in @user
    get new_user_location_path
    assert_redirected_to @user
  end

  test 'should redirect create if the current user already has a location' do
    sign_in @user
    assert_no_difference 'Location.count' do
      post user_locations_path, params: { location: attributes_for(:location) }
    end
    assert_redirected_to @user
  end

  test "should redirect edit if the current user's skill_list is empty" do
    @user.skill_list = []
    @user.save
    sign_in @user
    get edit_user_location_path(@user_location.id)
    assert_redirected_to edit_skill_list_path(@user.id)
  end

  test "should redirect update if the current user's skill_list is empty" do
    @user.skill_list = []
    @user.save
    sign_in @user
    patch user_location_path(@user_location.id), params: { location: 
                                                          { title: 'Wall Street',
                                                            latitude: 180,
                                                            longitude: 90 } }
    assert_redirected_to edit_skill_list_path(@user)
  end

  test "should redirect disable_location if the current user's skill_list is empty" do
    @user.skill_list = []
    @user.save
    sign_in @user
    patch disable_location_path(@user_location.id)
    assert_redirected_to edit_skill_list_path(@user)
  end

  test "should redirect edit, update, and disable_location if user_location doesn't belong to current user" do
    other_user = create(:confirmed_user_with_location_and_skills, location: @user.location)
    sign_in other_user
    # edit
    get edit_user_location_path(@user_location.id)
    assert_redirected_to root_url
    # update
    patch user_location_path(@user_location.id), params: { location: {
                                                              title: nil,
                                                              latitude: nil,
                                                              longitude: nil } }
    assert_redirected_to root_url
    # disable_location
    patch disable_location_path(@user_location.id)
    assert_redirected_to root_url
  end

  test 'successful UserLocation creation with valid location' do
    # For the purposes of this test, I leave the user's skill_list in tact,
    # in order to confirm the changes on the user's profile page are correct.
    # In real use of the application, this shouldn't occur like this. The user
    # should create their user_location then add some skills.
    @user.update(user_location: nil)
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
    @user.update(user_location: nil)
    sign_in @user
    assert_difference 'UserLocation.count', 1 do
      post user_locations_path, params: { user_location: { location_id: nil } }
    end
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    @user.reload
    assert_select 'div.user-location', text: "This user's location is secret"
    assert @user.user_location
    assert @user.user_location.disabled
    assert_nil @user.user_location.location
  end

  test 'unsuccessful UserLocation creation with invalid location' do
    @user.update(user_location: nil)
    sign_in @user
    assert_no_difference 'UserLocation.count' do
      post user_locations_path, params: { location: { title: @user_location.location.title,
                                                      latitude: 31,
                                                      longitude: 1 } }
    end
    assert_not flash.empty?
    assert_template 'user_locations/new'
    assert_select 'div.alert-danger'
  end

  test 'successful UserLocation update' do
    sign_in @user
    prev_loc = @user.location
    stafford = create(:location, title: 'Stafford, VA 22554, USA',
                                 latitude: 38.4220687,
                                 longitude: -77.4083086)
    patch user_location_path(@user_location.id), 
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
    assert prev_loc.users.empty?
  end

  test 'unsuccessful UserLocation update' do
    sign_in @user
    prev_loc = @user.location
    invalid_loc = { title: prev_loc.title,
                    latitude: 38.4220687,
                    longitude: -77.4083086 }
    patch user_location_path(@user_location.id), 
          params: { location: { title: invalid_loc[:title],
                                latitude: invalid_loc[:latitude],
                                longitude: invalid_loc[:longitude] } }
    assert_template 'user_locations/edit'
    assert_not flash.empty?
    assert_select 'div.alert-danger'
    @user.reload
    assert_equal prev_loc, @user.location
  end

  test 'disable_location with successful update' do
    sign_in @user
    prev_loc = @user.location
    patch disable_location_path(@user_location.id)
    @user.reload
    assert @user.user_location.disabled
    assert_nil @user.location
    patch user_location_path(@user_location.id),
          params: { location: { title: prev_loc.title,
                                latitude: prev_loc.latitude,
                                longitude: prev_loc.longitude } }
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    assert_select 'div.alert-success'
    assert_match prev_loc.title, response.body
    @user.reload
    assert_equal prev_loc, @user.location
    assert_not @user_location.disabled
  end
end
