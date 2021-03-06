# frozen_string_literal: true

require 'test_helper'
require 'carrier_wave_test_helper'
require 'fileutils'

class UserProfPicUploadTest < ActionDispatch::IntegrationTest
  def setup
    @carrierwave_root = Rails.root.join('test', 'support', 'carrierwave')
    @user = create(:confirmed_user_with_location_and_skills)
  end

  test 'successful profile picture upload with friendly forwarding' do
    get edit_user_url(@user)
    assert_redirected_to new_user_session_path
    follow_redirect!
    post new_user_session_path, params: { user: { email: @user.email,
                                                  password: @user.password } }
    assert_redirected_to edit_user_url(@user)
    follow_redirect!
    assert_template 'users/edit'
    valid_path = File.join(@carrierwave_root, 'uploads', 'valid')

    Dir.foreach(valid_path) do |f|
      next if (f == '.') || (f == '..')

      ext = ext(f)
      pic = fixture_file_upload(File.join(valid_path, f), "image/#{ext}")

      patch user_path(@user), params: { user: { profile_picture: pic } }
      prof_pic_ext = ext(assigns(:user).profile_picture.profile.url)

      assert_equal ext, prof_pic_ext
    end

    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_select 'img[src=?]', assigns(:user).profile_picture.profile.url
    assert_not flash.empty?
    assert_select 'div#flash'
    assert_select 'div.alert-success'
  end

  test "unsuccessful profile picture uploads" do
    sign_in @user
    invalid_path = File.join(@carrierwave_root, 'uploads', 'invalid')

    default_ext = ext(@user.profile_picture.profile.url)
    Dir.foreach(invalid_path) do |f|
      next if (f == '.') || (f == '..')

      ext = ext(f)
      file = fixture_file_upload(File.join(invalid_path, f), "image/#{ext}")
      get edit_user_path(@user.id)
      patch user_path(@user.id), params: { user: { profile_picture: file } }
      prof_pic_ext = ext(assigns(:user).profile_picture.profile.url)

      assert_equal default_ext, prof_pic_ext
    end

    assert_template 'users/edit'
    assert_select 'div#error_explanation'

    at_exit do
      puts 'Removing carrierwave test directories:'
      Dir.glob(@carrierwave_root.join('*')).each do |dir|
        puts "   #{dir}"
        FileUtils.remove_entry(dir)
      end
    end
  end
end
