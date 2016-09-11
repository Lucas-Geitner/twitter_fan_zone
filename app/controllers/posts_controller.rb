class PostsController < ApplicationController
  def create
    message = params["post"]["content"]
    categories=["Sympathisant", "Opposant", "Neutre", "Presse", "Inconnu", "Militant"]
    querry = params["post"]["destinataire"]
    redirect_to fans_path
    if categories.include? querry
      unless querry.nil? && querry == "Inconnu"
        TweetJob.perform_later(message, categories, querry)
      end
    end
  end
end

private

def post_param
  params.require(:post).permit(:content)
end
