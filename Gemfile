source "https://rubygems.org"
gemspec

group :test do
  gem "rake"
end

gem "jekyll-assets", "~> 2.2", :require => false

# Fix for travis
if (Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.2.2'))
  gem "rack", "< 2" 
end