class FansController < ApplicationController

  def get_the_data
    SearchJob.perform_later
    flash[:notice] = "La recherche est en cours, cela peut prendre un peu de temps"
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
    @fan.image_url = tweet.user.profile_image_url
    if @fan.image_url
      create_post(tweet)
      @fan.posts << @post
      @fan.counter_of_tweet = @fan.counter_of_tweet + 1
      @fan.url_fan = tweet.user.uri
      @fan.save
    end
    redirect_to @fan
  end

  def follow_them_all
    querry = params["genre"]
    unless querry.nil? && querry == "Inconnu"
      FollowJob.perform_later(querry)
      else
        @fans = Fan.all.order('counter_of_tweet DESC').limit(200)
    end
    redirect_to fans_path
  end

  def tweet_them_all
    querry = params["genre"]
    message = params["message"]
  end

  def list_of_them
    @fans = Fan.where(category: "Militant")
    @fan_for_message = []
    @fans.each do |fan|
      name = fan.url_fan.gsub("https://twitter.com/","@")
      @fan_for_message << name
    end
    @fan_for_message
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
end
