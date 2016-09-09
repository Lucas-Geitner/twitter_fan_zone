class FansController < ApplicationController

  def get_the_data
    @tweets = []
    @posts_ids = []
    @fans_names = []
    @searchs = ["to: benoithamon", "#benoithamon2017"]
    @searchs.each do |search|

      @client.search(search, result_type: "recent").take(2500).collect do |tweet|
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
          end
        end
      end
    end
    redirect_to fans_path

  end

  def index
    querry = params["genre"]
    if querry.nil?
      @fans = Fan.all.order('counter_of_tweet DESC').limit(200)
    else
      @fans = Fan.where(category: querry).order('counter_of_tweet DESC').limit(200)
    end
    @fan = Fan.new
  end

  def show

    id = params[:id]
    @fan = Fan.find(id)
    @posts = @fan.posts
  end

  def update
    id = params[:id]
    @fan = Fan.find(id)
    @fan.update(fan_param)
    redirect_to fan_path(@fan)
  end

  def create
    name = params["fan"]["name"]
    name.gsub!("@", "")
    twitteur = @client.user(name)
    @fan = Fan.new(name: twitteur.name, category: "Militant", contact: "Non Contacté")
    tweet = twitteur.tweet
    create_post(tweet)
    @fan.posts << @post
    @fan.counter_of_tweet = @fan.counter_of_tweet + 1
    @fan.image_url = tweet.user.profile_image_url
    @fan.url_fan = tweet.user.uri
    @fan.save
    redirect_to @fan
  end

  def follow_them_all
    querry = params["genre"]
    unless querry.nil? && querry == "Inconnu"
      @fans = Fan.where(category: querry).order('counter_of_tweet DESC').limit(200)
      @fans.each do |fan|
        id = fan.posts.first.tweeter_user_id.to_i
        @client.follow(id)
      end
      else
        @fans = Fan.all.order('counter_of_tweet DESC').limit(200)
    end
    redirect_to fans_path
  end

  def tweet_them_all
    querry = params["genre"]
    message = params["message"]
  end
end

private
def fan_param
  params.require(:fan).permit(:category, :name)
end

def create_post(tweet)
  @post = Post.new()
  @post.tweet_id = tweet.id.to_s
  @post.tweeter_user_id = tweet.user.id.to_s
  @post.url_post = tweet.uri
  @post.content = tweet.text
  @post.save
end
