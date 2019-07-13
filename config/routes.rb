# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controller: { passwords: 'users/passwords',
                                   registrations: 'users/registrations',
                                   sessions: 'users/sessions'}
end
