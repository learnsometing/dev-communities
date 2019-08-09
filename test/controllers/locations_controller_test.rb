# frozen_string_literal: true

require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  # def setup
  #   @user = create(:confirmed_user_without_location)
  # end

  # test 'should redirect new if logged out' do
  #   get new_location_path
  #   assert_redirected_to new_user_session_path
  # end

  # test 'should redirect create if logged out' do
  #   assert_no_difference 'Location.count' do
  #     post locations_path, params: { location: attributes_for(:location) }
  #   end
  #   assert_redirected_to new_user_session_path
  # end

  # test 'should redirect edit if logged out' do
  #   loc = create(:location)
  #   get edit_location_path(loc)
  #   assert_redirected_to new_user_session_path
  # end

  # test 'should redirect update if logged out' do
  #   loc = create(:location)
  #   patch location_path(loc), params: { location: attributes_for(:location) }
  #   assert_redirected_to new_user_session_path
  # end

  # test 'should redirect new if the current user already has a location' do
  #   location = create(:location)
  #   @user.create_user_location(location_id: location.id)
  #   sign_in @user
  #   get new_location_path
  #   assert_redirected_to @user
  # end

  # test 'should redirect create if the current user already has a location' do
  #   sign_in @user
  #   location = create(:location)
  #   @user.create_user_location(location_id: location.id)
  #   assert_no_difference 'Location.count' do
  #     post locations_path, params: { location: attributes_for(:location) }
  #   end
  #   assert_redirected_to @user
  # end
end
