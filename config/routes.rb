Rails.application.routes.draw do
  devise_for :users
  root to: 'fans#index'
  resources :posts, only: [:create]
  resources :messages, only: [:create, :index] do
    collection do
      get 'actualise'
    end
  end

  resources :fans do
    collection do
      get 'get_the_data'
      get 'list_of_them'
      get 'follow_them_all'
      get 'tweet_them_all'
    end
  end
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
