class MessagesController < ApplicationController
  def create
    message = params["message"]["sender"]
    categories=["Sympathisant", "Opposant", "Neutre", "Presse", "Inconnu", "Militant"]
    querry = params["message"]["destinataire"]
    if categories.include? querry
      unless querry.nil? && querry == "Inconnu"
        MessageJob.perform_later(message, categories, querry)
      end
    else
      querry = params["message"]["destinataire"].to_i
      message = params["message"]["sender"]
      MessageJob.perform_later(message, categories, querry)
    end

    redirect_to fans_path
    end

    def index
      @messages = Message.all
    end

    def actualise
      @messages = Message.all

      @messages_ids = []
      @messages.each do |m|
        @messages_ids << m.id
      end

      sleep 60
      @message_recu = @client.direct_messages
      @message_recu.each do |message|
        unless @messages_ids.include? message.id.to_s

          @message = Message.new(text: message.text, sender: message.sender.id)
          fan = Post.where(tweeter_user_id: message.sender.id).first.fan
          @message.direct_message_id = message.id
          @message.fan = fan
          @message.save
          fan.messages << @message
          fan.save
        end
      end

      redirect_to messages_path
    end

  private

  def post_param
    params.require(:post).permit(:content)
  end
end
