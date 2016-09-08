class PostsController < ApplicationController
  def create
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

private

def post_param
  params.require(:post).permit(:content)
end
