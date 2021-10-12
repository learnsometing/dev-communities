source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5.5'
# Use SCSS for stylesheets
gem 'sassc', '~> 2.0', '>= 2.0.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3', '>= 4.3.5'
gem 'jquery-ui-rails', '~> 6.0', '>= 6.0.1'
# Reduces boot times through caching; required in config/boot.rb
gem 'acts-as-taggable-on', '~> 6.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.3', '>= 4.3.1'
gem 'bootstrap-will_paginate'
gem 'chosen-rails', '~> 1.8', '>= 1.8.7'
gem 'carrierwave', '~> 1.3', '>= 1.3.1'
gem 'database_cleaner', '~> 1.7'
gem 'devise', '~> 4.6', '>= 4.6.2'
gem 'faker', '~> 1.9', '>= 1.9.6'
gem 'figaro'
gem 'mailboxer', '~> 0.15.1'
gem 'mini_magick', '~> 4.9', '>= 4.9.4'
gem 'omniauth-github'
gem 'rails-jquery-autocomplete', '~> 1.0', '>= 1.0.5'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'selenium-webdriver', '~> 3.142', '>= 3.142.3'
  gem 'capybara', '>= 2.15'
  gem 'minitest', '~> 5.11', '>= 5.11.3'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'
end

group :production do
  # Use SendGrid heroku addon to send emails in production
  gem 'sendgrid-ruby', '~> 6.0'
  gem 'fog', '~> 2.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
