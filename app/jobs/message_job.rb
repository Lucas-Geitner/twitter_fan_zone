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
            @message = Message.new(text: message, direct_message_id: @a.id.to_s, fan_id: fan.id) ## The @a seems to be shit!
            @message.sender = @a.sender.id.to_s
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
        @fan = Fan.find(querry)
          if @followers.include? @fan.id
          fan = @client.user(@fan.posts.first.tweeter_user_id.to_i)
          @a = @client.direct_message_create(fan, message)
          @message = Message.new(text: message, sender: @a.id.to_s, fan_id: fan.id)
          @message.sender = @a.sender.id.to_s
          @message.save
          @fan.messages << @message
          @fan.save
          sleep 60
        end
    end
  end
end
