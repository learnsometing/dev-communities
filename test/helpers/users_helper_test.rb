require './app/helpers/users_helper.rb'
require 'test_helper'

class UsersHelperTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers  
  def setup
    @friend = create(:user)
    @friend.confirm
    @requestor = create(:user)
    @requestor.confirm
    sign_in @requestor
  end

  test 'already_requested? returns false when requestor has yet to send request' do
    assert_not already_requested?(@user)
  end
end