# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  config.gem "mini_fb"
  #config.gem "paperclip"
  #config.gem "guid"
  config.gem "acts-as-taggable-on", :source => "http://gemcutter.org"
  config.gem 'will_paginate', :source=>"http://gemcutter.org"
  config.gem "rmagick", :lib=>"RMagick"
  #config.gem "formtastic"
  config.gem "geokit"
  config.gem "ajaxful_rating"
  config.gem "xml-sitemap"
  config.gem "delayed_job", :version=>'2.0.3'
  config.gem "twitter"
  config.gem 'url_shortener'
  config.gem 'hominid'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  #constants

  unless RAILS_ENV == 'development'
    #production FB APP
    FB_APP_ID = '148274231867171'
    FB_APP_SECRET = '3ab0266e2ced549a10825e9fa27a5c9c'
  else
    #development FB APP
    FB_APP_ID = '152829934728153'
    FB_APP_SECRET = 'c965296b325958d6727709d2b3d07015'
  end

  TWITTER_API_KEY = 'oiBWjTyp6zmrjyEt38h4Q'
  TWITTER_CONSUMER_KEY = 'oiBWjTyp6zmrjyEt38h4Q'
  TWITTER_CONSUMER_SECRET = '1mXIWvQiIC9Do5e7WBeeMfWGy6xiweGAbAfRnHStoE'
  TWITTER_ACCESS_TOKEN = '189051463-wZOnJkFR2Se6sgm47bJXrIVtoAGnQj0zhkeuk303'
  TWITTER_ACCESS_SECRET = 'kJxr2he4CjjUrFZQ4Et0NI3ose5aSMUnGFBScq3TFI'

  #The FB Access Token is the 'impersonation' token that FB provides
  #Once an admin has gotten an access token WITH 'manage_pages' permission, do the folowing to get token:
  #>> accts = MiniFB.get(user.fb_access_token,'me/accounts')
  #=> <#Hashie::Mash data=[<#Hashie::Mash access_token="148274231867171|1719c381f5f443846c526f68-1268428128|148248548547708|3gTZKfe5HDRZkqoAB8lMbCH0E2E" category="Websites" id="148248548547708" name="CarTagPics">]>

#  FB_ACCESS_TOKEN = '148274231867171|1719c381f5f443846c526f68-1268428128|148248548547708|3gTZKfe5HDRZkqoAB8lMbCH0E2E'
  #token moved to lib/facebook_adapter.rb
  FB_PAGE_ID = '148248548547708'
  
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.smtp_settings = {
    :address  => "localhost",
    :port  => 25,
    :domain  => "cartagpics.com"
  }
  config.action_mailer.sendmail_settings = {
    :location => '/usr/sbin/sendmail',
    :arguments => '-i -t'
  }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_charset = "iso-8859-1"
  
  ENV['RECAPTCHA_PUBLIC_KEY'] = '6Le4vbwSAAAAABD-MBsK9ns9rglCL-GVklTY10yI'
  ENV['RECAPTCHA_PRIVATE_KEY'] = '6Le4vbwSAAAAAEwm9EGtbAntuPpQzmmRHkeLzT_X'

  BITLY_API_LOGIN = 'dennijo'
  BITLY_API_KEY = 'R_a7c9b62f35502217af086e0a949ef974'

  MAILCHIMP_API_KEY = '7718d97b419d86bd7ad4f599deb78db9-us2'
end