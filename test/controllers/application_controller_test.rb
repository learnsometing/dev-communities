# frozen_string_literal: true

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:confirmed_user_without_location)
  end

  test 'ApplicationController should require a user to set their locaton' do
    sign_in @user
    get user_path(@user)
    assert_redirected_to new_user_location_path
  end
end
