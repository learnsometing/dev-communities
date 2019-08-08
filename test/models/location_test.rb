# frozen_string_literal: true

require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
  end

  test 'should be valid' do
    assert @location.valid?
  end

  test 'should not allow title to be nil' do
    @location.title = nil
    assert @location.invalid?
  end

  test 'should not allow latitude to be nil' do
    @location.latitude = nil
    assert @location.invalid?
  end

  test 'should not allow longitude to be nil' do
    @location.longitude = nil
    assert @location.invalid?
  end

  test 'should not be able to create copies of the same location' do
    # Only one location per google maps place should exist
    location = Location.new(title: @location.title,
                            latitude: @location.latitude,
                            longitude: @location.longitude)
    assert_no_difference 'Location.count' do
      location.save
    end
  end
end
