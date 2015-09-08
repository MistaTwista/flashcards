Rails.application.routes.draw do
  root 'home#index'
  resources :cards
  # resources :users
  resources :user_sessions
  resources :registrations, only: [:new, :create]
  resources :profiles, only: [:edit, :update]
  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  delete "oauth/:provider" => "oauths#destroy", :as => :delete_oauth

  resources :reviews, only: [:new, :create]
end
