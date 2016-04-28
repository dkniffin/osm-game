source 'https://rubygems.org'

gem 'rails', '>= 5.0.0.beta1', '< 5.1'
gem 'pg', '~> 0.18'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'mapbox-rails', github: 'dkniffin/mapbox-rails'
gem 'jbuilder', '~> 2.0'
gem 'puma'
gem 'sass'
gem 'devise', github: 'plataformatec/devise'
gem 'omniauth-facebook'
gem 'alchemist'
gem 'geocoder'
gem 'slim-rails'
gem 'active_interaction', '~> 3.0'
gem 'pickup'

# OSM Related things
gem 'activerecord-postgis-adapter', '~> 4.0.0.beta'

source 'https://rails-assets.org' do
  gem 'rails-assets-osmbuildings-gl'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.5.0.beta1'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :development do
  gem 'web-console', '~> 3.0'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
