# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_sto  `rage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
gem 'active_storage_validations' # ActiveStorage validations

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', require: 'rack/cors'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'annotate' # Annotate Rails classes with schema and routes info
  gem 'bullet' # Help to kill N+1 queries and unused eager loading
  gem 'byebug' # Debugging tool
  gem 'database_cleaner-active_record'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails' # Fixture replacement
  gem 'faker' # Generate fake data for testing
  gem 'pry-byebug' # Debugging tool
  gem 'pry-rails' # Debugging tool
  gem 'rails-controller-testing' # Test controllers
  gem 'rspec-rails' # Test framework
  gem 'rubocop' # Code style checker and formatter
  gem 'rubocop-discourse' # Code style checker and formatter
  gem 'rubocop-rails' # Code style checker and formatter
end

group :test do
  gem 'shoulda-matchers', '~> 5.0' # Testing library for Rails
  gem 'state_machines-rspec', '~> 0.6.0' # RSpec matchers for state_machines
end

# AUTHENTICATION AND PERMISSIONS
gem 'auth0' # Authentication
gem 'cancancan' # Authorization
gem 'jwt' # JSON Web Tokens

# SECURITY
gem 'dotenv-rails' # Manage environment variables.rb
gem 'rbnacl' # Encryption

# FUNCTIONALITY
gem 'email_validator' # Validates email addresses
gem 'httparty' # HTTP client
gem 'jsonapi-serializer' # JSON API serialization
gem 'will_paginate', '~> 3.3' # Pagination

# DEBBUGING
gem 'bugsnag' # Error monitoring
gem 'colorize' # Text colorizationgem 'memory_profiler' # Memory usage analysis
