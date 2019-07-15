# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    passwords: 'users/passwords',
                                    registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
end
