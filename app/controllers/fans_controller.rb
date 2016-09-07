class FansController < ApplicationController
  def index

  @tweets = []
  @posts_ids = []
  @fans_names = []

  @client.search("to:benoithamon", result_type: "recent").take(200).collect do |tweet|
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
      @post = Post.new()
      @post.tweet_id = tweet.id.to_s
      @post.tweeter_user_id = tweet.user.id.to_s
      @post.save
      unless @fans_names.include? tweet.user.name
        # Premier tweet d'un fanra
        @fan = Fan.new(name: tweet.user.name, category: "unknow", contact: "Pas encore contacté")
        @fan.posts << @post
        @fan.counter_of_tweet = @fan.counter_of_tweet + 1
        @fan.image_url = tweet.user.profile_image_url
        @fan.save
      else
        @fan = Fan.where(name: tweet.user.name).first
        @fan.posts << @post
        @fan.counter_of_tweet = @fan.counter_of_tweet + 1
        @fan.save
      end
    end
    querry = params["genre"]
    if querry == "presse"
      @fans = Fan.where(category: "presse").order('counter_of_tweet DESC').limit(200)
    elsif querry == "unknow"
      @fans = Fan.where(category: "unknow").order('counter_of_tweet DESC').limit(200)
    elsif querry == "sympathisant"
      @fans = Fan.where(category: "sympathisant").order('counter_of_tweet DESC').limit(200)
    elsif querry == "sympathisant"
      @fans = Fan.where(category: "neutre").order('counter_of_tweet DESC').limit(200)
    else
    @fans = Fan.all.order('counter_of_tweet DESC').limit(200)
  end
  end
end
  def show
    id = params[:id]
    @fan = Fan.find(id)
  end
  def update
    id = params[:id]
    @fan = Fan.find(id)
    @fan.update(fan_param)
    redirect_to fan_path(@fan)
  end
end

private
def fan_param
  params.require(:fans).permit(:category)
end
