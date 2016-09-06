class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :authenticate_twitter
  # before_action :configure_permitted_parameters, if: :devise_controller?
  # rescue_from ActiveResource::ClientError, with: :shopify_client_error

def authenticate_twitter
  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACESS_TOKEN"]
    config.access_token_secret = ENV["ACESS_TOKEN_SECRET"]
  end
end
end
