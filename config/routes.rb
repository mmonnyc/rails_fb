Rails.application.routes.draw do
  root "posts#index"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  resources :users, only: [:index, :show] do
    resources :friendships, only: [:create] do
      collection do
        get 'accept_friend'
        get 'decline_friend'
      end
    end
  end

  put '/users/:id', to: 'users#update_img'

  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    resources :likes, only: [:create]
    resources :comments, only: [:new, :create, :destroy] do
      resources :likes, only: [:create]
    end
  end

end
