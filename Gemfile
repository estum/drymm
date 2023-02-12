# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in drymm.gemspec
gemspec

gem "rake", "~> 13.0"

group :test do
  gem "rspec"
  gem "rspec-instafail", require: false
  gem "simplecov", require: false, platforms: :ruby
  gem "warning"
end

group :tools do
  gem "yard"
  gem "byebug"
  gem "rubocop", "~> 1.40.0"
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
end

group :console do
  gem "pry"
  gem "pry-byebug"
  gem "wirb"
end
