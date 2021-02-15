source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.0.0"

gem "autoprefixer-rails"

gem "bootsnap", require: false
gem "honeybadger"
gem "pg"
gem 'puma', '~> 4.0'
gem "rack-canonical-host"
gem "rails", "~> 6.1.0"
gem "recipient_interceptor"
gem "sassc-rails"
gem "skylight"
gem "sprockets", "< 4"
gem "title"
gem "tzinfo-data", platforms: [:mingw, :x64_mingw, :mswin, :jruby]
gem "webpacker"
gem "hotwire-rails", "~> 0.1.0"

group :development do
  gem "listen"
  gem 'web-console', '>= 4.1.0'
  gem 'capistrano3-puma', '~> 4.0'
  gem 'capistrano', '~> 3.15',  require: false
  gem 'capistrano-rails', '~> 1.6',  require: false
  gem 'rvm1-capistrano3', require: false
  # gem 'capistrano-rvm'
  gem 'capistrano-bundler', '~> 2.0', require: false
  gem 'capistrano-faster-assets', '~> 1.0'
  gem 'capistrano-postgresql', '~> 6.2.0'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-sidekiq', '~> 1', group: :development
  gem 'capistrano-rails-logs-tail'
end

group :development, :test do
  gem "awesome_print"
  gem "pry-byebug"
  gem "pry-rails"
end

group :test do
  gem "formulaic"
  gem "launchy"
  gem "timecop"
  gem "webmock"
end

