class FansController < ApplicationController
  def index

  @tweets = []

  @client.search("to:benoithamon", result_type: "recent").take(5).collect do |tweet|
      if tweet.id.to_s != Post.where(tweet_id: tweet.id.to_s)
      # Le tweet n'à pas encore été rajoutée.
      @post = Post.create(tweet_id: tweet.id.to_s, fan_id: tweet.user.id.to_s)
      if tweet.user.id != Fan.where(name: tweet.user.name)
        # Premier tweet d'un fan
        @fan = Fan.create(name: tweet.user.name, category: "unknow", contact: "Pas encore contacté")
        @fan.posts << @post
        @fan.save
      else
        # Incrementer le tweet au fan !
      end
    end
    @fans = Fan.all
    # @tweets << "#{tweet.user.screen_name}: #{tweet.text}"
  end
end
end
