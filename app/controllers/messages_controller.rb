class MessagesController < ApplicationController
  def create
      message = params["message"]["sender"]
      categories=["Sympathisant", "Opposant", "Neutre", "Presse", "Inconnu", "Militant"]
      querry = params["message"]["destinataire"]
      @followers = []
      @client.followers.each do |folower|
        @followers << folower.id
      end

      if categories.include? querry
        unless querry.nil? && querry == "Inconnu"
          @fans = Fan.where(category: querry).order('counter_of_tweet DESC').limit(200)
          @fans.each do |fan|
            id = fan.posts.first.tweeter_user_id.to_i
            fane = @client.user(id)
            if @followers.include? fane.id
              @a = @client.direct_message_create(fane, message)
              @message = Message.new(text: message, sender: @a.id, fan_id: fan.id)
              @message.save
              fan.messages << @message
              fan.save
            end
          end
        else
        @fans = Fan.all.order('counter_of_tweet DESC').limit(200)
        end
        redirect_to fans_path
      else
          user = params["post"]["destinataire"].to_i
          message = params["post"]["sender"]
          @fan = Fan.find(user)
          fan = @client.user(@fan.posts.first.tweeter_user_id.to_i)
          @a = @client.update("@#{fan.screen_name} #{message}")
          @message = Post.new(text: message, sender: @a.id, fan_id: fan.id)
          @message.save
          @fan.posts << @message
          @fan.save
          redirect_to fan_path(@fan)
      end
    end

  private

  def post_param
    params.require(:post).permit(:content)
  end
end
