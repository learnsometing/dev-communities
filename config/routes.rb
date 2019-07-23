# frozen_string_literal: true

Rails.application.routes.draw do
  get 'friendships/create'
  get 'friendships/destroy'
  root 'users#show'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
  resources :users, only: %i[show edit update]
  resources :posts, only: %i[create edit update destroy]
  resources :friend_requests, only: %i[create destroy]
  get '/friend_request_notifications', to: 'notification_changes#friend_request_notifications'
  resources :friendships, only: %i[create destroy]
end
