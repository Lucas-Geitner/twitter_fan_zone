class FansController < ApplicationController
  def index

  @tweets = []

  @client.search("to:benoithamon", result_type: "recent").take(5).collect do |tweet|
      if tweet.id != Post.where(tweet_id: tweet.id)
      # Le tweet n'à pas encore été rajoutée.
      Post.create(tweet_id: tweet.id, fan_id: tweet.user.id)
      if tweet.user.id != Fan.where(name: tweet.user.name)
        # Premier tweet d'un fan
        Fan.create(name: tweet.user.name, category: "unknow", contact: "Pas encore contacté")
      else
        # Incrementer le tweet au fan !
      end
    end
    @fans = Fan.all
    # @tweets << "#{tweet.user.screen_name}: #{tweet.text}"
  end
end
end
