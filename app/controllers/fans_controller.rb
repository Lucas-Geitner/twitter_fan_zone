class FansController < ApplicationController
  def index

  @tweets = []


  @client.search("to:benoithamon", result_type: "recent").take(500).collect do |tweet|
      if tweet.id.to_s != Post.where(tweet_id: tweet.id.to_s)
      # Le tweet n'à pas encore été rajoutée.
      @post = Post.new()
      @post.tweet_id = tweet.id.to_s
      @post.tweeter_user_id = tweet.user.id.to_s
      @post.save
      if tweet.user.name != Fan.where(name: tweet.user.name)
        # Premier tweet d'un fanra
        @fan = Fan.create(name: tweet.user.name, category: "unknow", contact: "Pas encore contacté")
        @fan.posts << @post
        @fan.save
      else
        @fan = Fan.where(name: tweet.user.name)
        @fan.posts << @post
        @fan.save
      end
    end
    @fans = Fan.all
    # @tweets << "#{tweet.user.screen_name}: #{tweet.text}"
  end
end
end
