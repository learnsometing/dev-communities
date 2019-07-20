# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#show'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
  resources :users, only: %i[show edit update]
  resources :posts, only: %i[create edit update destroy]
  resources :friend_requests, only: %i[create]
  get '/friend_requests', to: 'notification_changes#friend_request_notifications'
end
