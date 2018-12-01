# frozen_string_literal: true

source "https://rubygems.org"

gem "jekyll", "~> 3.7.0"

group :jekyll_plugins do
  gem "github-pages"
  gem "jekyll-feed"
  gem "jekyll-paginate"
  gem "kramdown"
  gem "rouge"
end

require 'rbconfig'
if RbConfig::CONFIG['target_os'] =~ /darwin(1[0-3])/i
  gem 'rb-fsevent', '<= 0.9.4'
end
