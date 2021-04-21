Rails.application.routes.draw do
  root "users#index"
  devise_for :users
  
  resources :users, only: [:index, :show] do
    resources :friendships, only: [:create]
  end
  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    resources :likes, only: [:create]
  end
  resources :comments, only: [:new, :create, :destroy] do
    resources :likes, only: [:create]
  end

end
