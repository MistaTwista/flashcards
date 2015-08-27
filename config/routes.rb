Rails.application.routes.draw do
  root 'home#index'
  resources :cards
  resources :reviews, only: [:new, :create]
end
