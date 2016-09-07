class FansController < ApplicationController
  def index

  @tweets = []

  @client.search("to:benoithamon", result_type: "recent").take(200).collect do |tweet|
    @tweets = tweet.user.name
      if tweet.id != Post.find_by(tweet_id: tweet.id)
      # Le tweet n'à pas encore été rajoutée.
      @post = Post.create(tweet_id: tweet.id, fan_id: tweet.user.id)
      if tweet.user.name != Fan.where({name: tweet.user.name})
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
