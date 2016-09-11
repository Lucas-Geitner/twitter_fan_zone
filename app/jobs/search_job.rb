class SearchJob < ApplicationJob
  queue_as :search

  def perform()
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACESS_TOKEN"]
      config.access_token_secret = ENV["ACESS_TOKEN_SECRET"]
    end
    puts "I'm starting the Search job"
    @tweets = []
    @posts_ids = []
    @fans_names = []
    @searchs = ["to: benoithamon", "#benoithamon2017", "#lagauchepourgagner"]
    @searchs.each do |search|
      sleep 0.2
      @client.search(search, result_type: "recent").take(2000).collect do |tweet|
        @posts = Post.all
        @posts.each do |post|
          @posts_ids << post.tweet_id
        end
        @fans = Fan.all
        @fans.each do |fan|
          @fans_names << fan.name
        end
        # a = Post.where(tweet_id: tweet.id.to_s).first.tweet_id
        unless @posts_ids.include? tweet.id.to_s
          # Le tweet n'à pas encore été rajoutée.
          create_post(tweet)
          unless @fans_names.include? tweet.user.name
            # Premier tweet d'un fanra
            @fan = Fan.new(name: tweet.user.name, category: "Inconnu", contact: "Non Contacté")
            @fan.posts << @post
            @fan.counter_of_tweet = @fan.counter_of_tweet + 1
            @fan.image_url = tweet.user.profile_image_url
            @fan.url_fan = tweet.user.uri
            @fan.save
          else
            @fan = Fan.where(name: tweet.user.name).first
            @fan.posts << @post
            @fan.counter_of_tweet = @fan.counter_of_tweet + 1
            @fan.save
            puts "#{@fan.name} have been created!"
          end
        end
      end
    end
  end
end
