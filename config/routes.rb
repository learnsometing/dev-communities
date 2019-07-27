# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users, controllers: { confirmations: 'users/confirmations',
                                    omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations',
                                    sessions: 'users/sessions' }

  devise_scope :user do 
    get '/users/feed', to: 'users#feed', as: 'user_root'
  end

  resources :users, only: %i[show edit update]
  resources :posts, only: %i[create show edit update destroy]
  resources :friend_requests, only: %i[create destroy]
  get '/friend_request_notifications', to: 'notifications#friend_request_notifications'
  get '/notifications', to: 'notifications#index'
  post '/mark_as_read', to: 'notifications#mark_as_read'
  resources :friendships, only: %i[create index destroy]
  resources :locations, only: %i[new create edit update]
  patch '/locations/:id/disable', to: 'locations#disable', as:'disable_location'
end
