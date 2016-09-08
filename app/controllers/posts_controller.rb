class PostsController < ApplicationController
  def create
    raise
      user = params("id").to_i
      message = params("message")
      @fan = Fan.find(user)
      @client.update("#{@fan.name} #{message}")
      ## raise
      @post = Post.new(content: message, tweet_id: blabla, tweeter_user_id: blabla, destinataire: @fan.name  )
      @Post.save
      @fan << @post
      @fan.save
      redirect_to fan_path(@fan)
  end
end

private

def post_param
  params.require(:post).permit(:content)
end
