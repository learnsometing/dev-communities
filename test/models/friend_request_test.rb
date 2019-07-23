# frozen_string_literal: true

require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @friend = create(:confirmed_user)
    @requestor = create(:confirmed_user)
    @request = @requestor.sent_friend_requests.build(friend_id: @friend.id)
  end

  test 'friend request with friend id and requestor id should be valid' do
    assert @request.valid?
  end

  test 'request should require a friend id' do
    @request.friend_id = nil
    assert @request.invalid?
  end

  test 'request should require a requestor id' do
    @request.requestor_id = nil
    assert @request.invalid?
  end

  test 'a friend should only be able to recieve one request per requestor' do
    assert_difference 'FriendRequest.count', 1 do
      @request.save
      @dup_request = @request.dup
      @dup_request.save
    end

    assert_equal @dup_request.errors.count, 1
  end

  test 'a notification should be created upon creation of the request' do
    assert_difference '@friend.notifications.count', 1 do
      @request.save
    end
  end

  test 'a notification object should be created upon creation of the request' do
    assert_difference '@request.notification_objects.count', 1 do
      @request.save
    end
  end

  test 'a notification change should be created upon creation of the request' do
    assert_difference '@requestor.notification_changes.count', 1 do
      @request.save
    end
  end

  test 'notification should have an appropriate description' do
    @request.save

    expected_description = "#{@requestor.name} sent you a friend request."
    actual_description = @friend.notifications.first.description

    assert_equal expected_description, actual_description
  end

  test 'associated notification objects should be destroyed' do
    @request.save

    assert_difference 'NotificationObject.count', -1 do
      @request.destroy
    end
  end

  test 'accept should updated the accepted attribute' do
    @request.save
    assert_not @request.accepted
    @request.accept
    assert @request.accepted
  end
end
