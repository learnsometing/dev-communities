# frozen_string_literal: true

require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
  end

  test 'should be valid' do
    assert @location.valid?
  end

  test 'should not allow a location to be created with the same user_id' do
    assert build(:location, user_id: @location.user_id).invalid?
  end

  test 'should allow latitude to be nil' do
    @location.latitude = nil
    assert @location.valid?
  end

  test 'should allow longitude to be nil' do
    @location.longitude = nil
    assert @location.valid?
  end
end
