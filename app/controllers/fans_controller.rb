class FansController < ApplicationController
  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "6j0V6TgAkwkJvsQUG6P67uBMB"
      config.consumer_secret     = "yMw82b0m3yJw04KycGnpgFyKtDUnxAyZ3ojjC0F2StDxFcvxgE"
      config.access_token        = "472002207-R5uUhJLPCqUBDFqlJckp378ianpBTRwcZfESZ5vU"
      config.access_token_secret = "cPXSMOt7b2nKONvMTi4YzRYwlWXgtwcdYOrbL4jQKt6zL"
    end
  @tweets = []

  client.search("to:benoithamon", result_type: "recent").take(200).collect do |tweet|
      if tweet.id != Post.find(tweet.id)
      # Le tweet n'à pas encore été rajoutée.
      Post.new(id: tweet.id, text: tweet.text, user_id: tweet.user.id)
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
