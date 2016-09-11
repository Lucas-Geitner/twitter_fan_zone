class MessageJob < ApplicationJob
  queue_as :message

  def perform(message, categories, querry)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACESS_TOKEN"]
      config.access_token_secret = ENV["ACESS_TOKEN_SECRET"]
    end
    # Do something later
      @followers = []
      @client.followers.each do |folower|
      @followers << folower.id
    end

    if categories.include? querry
      unless querry.nil? && querry == "Inconnu"
        @fans = Fan.where(category: querry).order('counter_of_tweet DESC').limit(200)
        @fans.each do |fan|
          id = fan.posts.first.tweeter_user_id.to_i
          fane = @client.user(id)
          if @followers.include? fane.id
            @a = @client.direct_message_create(fane, message)
            @message = Message.new(text: message, sender: @a.id, fan_id: fan.id)
            @message.save
            fan.messages << @message
            fan.save
            sleep 60
          end
        end
      else
      @fans = Fan.all.order('counter_of_tweet DESC').limit(200)
      end
      else
        user = params["post"]["destinataire"].to_i
        message = params["post"]["sender"]
        @fan = Fan.find(user)
        fan = @client.user(@fan.posts.first.tweeter_user_id.to_i)
        @a = @client.direct_message_create(fan, message)
        @a = @client.update("@#{fan.screen_name} #{message}")
        @message = Post.new(text: message, sender: @a.id, fan_id: fan.id)
        @message.save
        @fan.posts << @message
        @fan.save
        sleep 60
    end
  end
end
