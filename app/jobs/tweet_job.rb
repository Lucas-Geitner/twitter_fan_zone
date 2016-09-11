class TweetJob < ApplicationJob
  queue_as :default

  def perform(message, categories, querry)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACESS_TOKEN"]
      config.access_token_secret = ENV["ACESS_TOKEN_SECRET"]
    end

    if categories.include? querry
      unless querry.nil? && querry == "Inconnu"
        @fans = Fan.where(category: querry).order('counter_of_tweet DESC').limit(200)
        @fans.each do |fan|
          id = fan.posts.first.tweeter_user_id.to_i
          fane = @client.user(id)
          @a = @client.update("@#{fane.screen_name} #{message}")
          @post = Post.new(content: message, tweet_id: @a.id, tweeter_user_id: @a.user.id, destinataire: fan.name  )
          @post.save
          fan.posts << @post
          fan.save
          sleep 60
        end
        
      else
      @fans = Fan.all.order('counter_of_tweet DESC').limit(200)
      end
    else
        user = params["post"]["destinataire"].to_i
        message = params["post"]["content"]
        @fan = Fan.find(user)
        fan = @client.user(@fan.posts.first.tweeter_user_id.to_i)
        @a = @client.update("@#{fan.screen_name} #{message}")
        @post = Post.new(content: message, tweet_id: @a.id, tweeter_user_id: @a.user.id, destinataire: @fan.name  )
        @post.save
        @fan.posts << @post
        @fan.save
        sleep 60
    end
  end
end
