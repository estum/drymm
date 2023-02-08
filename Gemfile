# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in drymm.gemspec
gemspec

gem "rake", "~> 13.0"

group :test do
  gem "simplecov", require: false, platforms: :ruby
  gem "rspec"
  gem "warning"
  gem "rspec-instafail", require: false
end

group :tools do
  gem "rubocop", "~> 1.40.0"
  gem "byebug"
end

group :console do
  gem "pry"
  gem "pry-byebug"
end