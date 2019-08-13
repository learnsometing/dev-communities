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

  resources :users do
    get :autocomplete_skill_name, on: :collection
    get '/search', to: 'users#search', on: :collection
  end

  get 'users/:id/edit_skill_list', to: 'users#edit_skill_list', as: 'edit_skill_list'
  resources :posts, only: %i[create show edit update destroy]
  resources :friend_requests, only: %i[create destroy]
  resources :notifications, only: %i[index destroy]
  get '/friend_request_notifications', to: 'notifications#friend_request_notifications'
  resources :friendships, only: %i[create destroy]
  get 'users/:id/friends', to: 'users#friends', as: 'friend_list'
  resources :user_locations, only: %i[new create edit update]
  patch '/user_locations/:id/disable', to: 'user_locations#disable_location', as: 'disable_location'

  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
      post :restore
      post :mark_as_read
    end
    collection do
      delete :empty_trash
    end
  end
  resources :messages, only: [:new, :create]
end
