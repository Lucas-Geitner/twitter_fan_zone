class FollowJob < ApplicationJob
  queue_as :default

  def perform(querry)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACESS_TOKEN"]
      config.access_token_secret = ENV["ACESS_TOKEN_SECRET"]
    end
    @fans = Fan.where(category: querry).order('counter_of_tweet DESC').limit(200)
    @fans.each do |fan|
      id = fan.posts.first.tweeter_user_id.to_i
      @client.follow(id)
      puts "We follow someone else"
      sleep 60
    end
  end
end
