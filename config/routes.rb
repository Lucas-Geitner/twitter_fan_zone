Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :fans do
    collection do
      get 'get_the_data'
      get 'follow_them_all'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
