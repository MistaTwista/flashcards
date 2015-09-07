Rails.application.routes.draw do
  root 'home#index'
  resources :cards
  resources :users
  resources :user_sessions
  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
  resources :reviews, only: [:new, :create]
end
