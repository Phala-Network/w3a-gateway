# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "collectors/page_view"
  get "scooby", to: "collectors#page_view"

  root to: "home#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create]
      resource :sessions, only: %i[new show create update destroy]

      resources :sites, only: %i[index show create destroy]
    end
  end
end
