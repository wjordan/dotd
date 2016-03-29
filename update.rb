#!/usr/bin/env ruby
Dir.chdir __dir__
require 'rubygems'
require 'bundler/setup'

# Update the current dev of the day in HipChat developer room.
# To use: update_dev_of_day.rb

require 'active_support'
require 'active_support/core_ext'

require 'httparty'
require 'hipchat'
require 'dotenv'
Dotenv.load

DEV_OF_DAY_SCHEDULE = 'PPQ1NPZ'
PAGERDUTY_TOKEN = ENV['PAGERDUTY_TOKEN'] || raise('PAGERDUTY_TOKEN required')
HIPCHAT_TOKEN = ENV['HIPCHAT_TOKEN'] || raise('HIPCHAT_TOKEN required')
PAGERDUTY_API = 'https://codeorg.pagerduty.com/api/v1'

url = "#{PAGERDUTY_API}/schedules/#{DEV_OF_DAY_SCHEDULE}/users"

now = Time.now
future = now + 1.minutes
schedule = HTTParty.get(url, query: {since: now.iso8601, 'until' => future.iso8601}, headers: {'Authorization' => "Token token=#{PAGERDUTY_TOKEN}"})
dev_of_day_email = schedule['users'].first['email']

hipchat = HipChat::Client.new(HIPCHAT_TOKEN, :api_version => 'v2')
dev_name = hipchat.user(dev_of_day_email).view
mention_name = dev_name.mention_name

topic = hipchat['Developers'].get_room['topic']
new_topic = topic.gsub(/(?<= )[^\s]*(?= is dev of the day)/, "@#{mention_name}")
#unless topic == new_topic
#  hipchat['Developers'].topic(new_topic)
#  puts 'Dev of day topic updated'
#end
puts "Topic = #{new_topic}"
