# config/initializers/pusher.rb
require 'pusher'
Pusher.app_id = '822793'
Pusher.key = '652c72b82c6ef51a23cf'
Pusher.secret = '6eae5b4e32b5e8e90802'
Pusher.cluster = 'us2'
Pusher.logger = Rails.logger
Pusher.encrypted = true
