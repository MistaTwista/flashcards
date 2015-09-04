Rails.application.routes.draw do
  root 'home#index'
  resources :cards
  resources :users
  resources :reviews, only: [:new, :create]
end
