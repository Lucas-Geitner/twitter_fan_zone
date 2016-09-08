Rails.application.routes.draw do
  devise_for :users
  root to: 'fans#index'
  resources :posts
  resources :fans do
    collection do
      get 'get_the_data'
      get 'follow_them_all'
      get 'tweet_them_all'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
