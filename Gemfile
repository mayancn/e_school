source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.7'
# Use Puma as the app server
gem 'puma', '~> 3.7'
gem 'mini_racer'
gem "autoprefixer-rails"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

#Gem for CK-Editor
gem 'ckeditor'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
#Gem mongoid for database instead on sqlite
gem 'mongoid', '~> 6.0'
gem 'bson_ext'
# Gem to convert erb to haml and use haml
gem 'haml'
gem 'html2haml'
gem "jquery-rails"

gem 'font-awesome-sass'
# gem 'bootstrap-growl-rails'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'popper_js'

gem 'bootstrap', '~> 4.3', '>= 4.3.1'
# Gem of the theme
gem 'bootstrap_sb_admin_base_v2', '~> 0.3.5'

# Gem devise to install a secure Authentication to the Application
gem 'devise'
gem 'devise_token_auth', git: 'https://github.com/lynndylanhurley/devise_token_auth.git', branch: 'master'
gem 'devise_invitable', '~> 2.0.0'
gem 'mongoid-locker'
# Gem for simplifying the form building process -- simple_form
gem 'simple_form'
#Gem for nested form
gem "cocoon"
# Gem for Role Based Authorization
gem 'cancancan'
# Gem for api auth token
gem 'simple_token_authentication', '~> 1.0'
#Gem to read Excel
gem "roo", "~> 2.7.0"
#gem to create PDF
gem "prawn"
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'pretender'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]