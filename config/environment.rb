# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.gem "adzap-ar_mailer", :lib => 'action_mailer/ar_mailer', :source => 'http://gems.github.com'

  config.gem "calendar_date_select"
  
  config.active_record.observers = :user_observer, :blog_observer, :photo_observer, :event_observer, :participation_observer, :poll_observer

  config.time_zone = 'UTC'

end
