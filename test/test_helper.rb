# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'fileutils'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  # Add more helper methods to be used by all tests here...
  def user_logged_in?
    !cookies['_dev_communities_session'].nil?
  end

  def ext(file)
    File.extname(file).strip.downcase[1..-1]
  end
end

# Carrierwave setup and teardown
carrierwave_template = Rails.root.join('test', 'fixtures', 'files')
carrierwave_root = Rails.root.join('test', 'support', 'carrierwave')

# Carrierwave configuration is set here instead of in initializer
CarrierWave.configure do |config|
  config.root = carrierwave_root
  config.enable_processing = false
  config.storage = :file
  config.cache_dir = Rails.root.join('test', 'support', 'carrierwave', 'carrierwave_cache')
end

# And copy carrierwave template in
puts "Copying\n  #{carrierwave_template.join('uploads')} to\n  #{carrierwave_root}"
FileUtils.cp_r carrierwave_template.join('uploads'), carrierwave_root


