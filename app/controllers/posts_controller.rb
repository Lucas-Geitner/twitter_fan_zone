class PostsController < ApplicationController
  def create
    message = params["post"]["content"]
    categories=["Sympathisant", "Opposant", "Neutre", "Presse", "Inconnu", "Militant"]
    querry = params["post"]["destinataire"]
    if categories.include? querry
      unless querry.nil? && querry == "Inconnu"
        @fans = Fan.where(category: querry).order('counter_of_tweet DESC').limit(200)
        @fans.each do |fan|
          id = fan.posts.first.tweeter_user_id.to_i
          fane = @client.user(id)
          @a = @client.direct_message_create(fane, "message")
          # @client.direct_message_create(fane, "hello Emma")
          # @a = @client.update("@#{fane.screen_name} #{message}")
          @post = Post.new(content: message, tweet_id: @a.id, tweeter_user_id: @a.user.id, destinataire: fan.name  )
          @post.save
          fan.posts << @post
          fan.save
        end
      else
      @fans = Fan.all.order('counter_of_tweet DESC').limit(200)
      end
      redirect_to fans_path
    else
        user = params["post"]["destinataire"].to_i
        message = params["post"]["content"]
        @fan = Fan.find(user)
        fan = @client.user(@fan.posts.first.tweeter_user_id.to_i)
        @a = @client.update("@#{fan.screen_name} #{message}")
        @post = Post.new(content: message, tweet_id: @a.id, tweeter_user_id: @a.user.id, destinataire: @fan.name  )
        @post.save
        @fan.posts << @post
        @fan.save
        redirect_to fan_path(@fan)
    end
  end
end

private

def post_param
  params.require(:post).permit(:content)
end
