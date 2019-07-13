# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { passwords: 'users/passwords',
                                    registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
end
