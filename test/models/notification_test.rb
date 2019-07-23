# frozen_string_literal: true

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  def setup
    @notification = Notification.new(user: create(:confirmed_user))
  end

  test 'notification should require a description' do
    assert @notification.invalid?
  end
end
