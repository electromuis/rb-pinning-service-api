source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sassc-rails'
gem 'sprockets-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'ipfs-http-client', github: 'VanwaTech/ipfs-http-client'
gem 'pagy', '~> 3.11'
gem 'dotenv-rails'
gem 'sidekiq'
gem 'redis', '~> 4.6' # Used for caching and Sidekiq.
gem 'connection_pool', '~> 2.2'
gem 'foreman'
gem 'jquery-rails'
gem 'bootstrap'
gem 'octicons_helper'
gem "chartkick"
gem 'groupdate'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'cid', github: 'andrew/ruby-cid', branch: 'main'

group :development do
  gem 'listen', '~> 3.2'
end

group :test do
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
