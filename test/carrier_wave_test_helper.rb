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

def ext(file)
  File.extname(file).strip.downcase[1..-1]
end