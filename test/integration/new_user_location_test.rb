require 'test_helper'

class NewUserLocationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  # Reset sessions and driver between tests
  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def setup
    @user = create(:confirmed_user)
  end

  test 'new user_location interface' do
    sign_in @user
    visit(new_user_location_path)
    # Initial page expectations
    page.assert_selector('div#trans-layer', count: 1)
    page.assert_selector('div#location-notice', count: 1)
    page.assert_selector('button#yes', count: 1)
    page.assert_selector('form#decline-form', count: 1)
    # Accept the location services
    location_notice = page.find('div#location-notice')
    yes_button = location_notice.find('button#yes')
    yes_button.click
    page.assert_no_selector('div#location-notice')
    # State of page after accepting
    page.assert_selector('div#location-instructions')
    page.assert_selector('button#got-it')
    # Dismiss the location instructions
    got_it = page.find('button#got-it')
    got_it.click
    # State of page after dismissing instructions
    page.assert_no_selector('div#translayer')

    # As far as I could get. Was not able to access google maps correctly
    
    # page.assert_selector('input#pac-input')
    # page.assert_selector('div#map')
  end


end
