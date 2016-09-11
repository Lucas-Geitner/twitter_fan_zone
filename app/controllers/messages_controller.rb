class MessagesController < ApplicationController
  def create
    message = params["message"]["sender"]
    categories=["Sympathisant", "Opposant", "Neutre", "Presse", "Inconnu", "Militant"]
    querry = params["message"]["destinataire"]
    if categories.include? querry
      unless querry.nil? && querry == "Inconnu"
        MessageJob.perform_later(message, categories, querry)
      end
    end
    redirect_to fans_path
    end

  private

  def post_param
    params.require(:post).permit(:content)
  end
end
