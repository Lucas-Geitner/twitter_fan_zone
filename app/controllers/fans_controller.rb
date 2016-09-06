class FansController < ApplicationController
  def index

  @tweets = []

  @client.search("to:benoithamon", result_type: "recent").take(200).collect do |tweet|
    raise
      if tweet.id != Post.find(tweet.id)
      # Le tweet n'à pas encore été rajoutée.
      # Post.new(id: tweet.id, text: tweet.text, user_id: tweet.user.id)
      if tweet.user.id != Fan.find(tweet.user.id)
        # Premier tweet d'un fan
      else
        # Incrementer le tweet au fan !

      end
    end
    @tweets << "#{tweet.user.screen_name}: #{tweet.text}"
  end
end
end
