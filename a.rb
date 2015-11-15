require 'fitgem'
require 'pp'

consumer_key = ENV['CONSUMER_KEY']
consumer_secret = ENV['CONSUMER_SECRET']
verifier = ENV['OAUTH_VERIFIER']

client = Fitgem::Client.new({:consumer_key => consumer_key, :consumer_secret => consumer_secret})

unless verifier
  request_token = client.request_token
  token = request_token.token
  secret = request_token.secret

  puts "Go to http://www.fitbit.com/oauth/authorize?oauth_token=#{token} and then enter the verifier code below and hit Enter"
  verifier = gets.chomp
  access_token = client.authorize(token, secret, { :oauth_verifier => verifier })
else
  access_token = client.reconnect(token, secret)
end

p access_token

puts "Verifier is: "+verifier
puts "Token is:    "+access_token.token
puts "Secret is:   "+access_token.secret

loop {
  device = client.devices.first

  p device

  time = Time.parse(device['lastSyncTime'])

  p time

  pp client.heart_rate_on_date(time)

  sleep 60
}
