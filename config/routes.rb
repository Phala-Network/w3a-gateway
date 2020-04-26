# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "collectors/page_view"
  get "scooby", to: "collectors#page_view"

  root to: "home#index"

  namespace :api do
    namespace :admin_v1 do
      resources :users, only: %i[create]
      resource :sessions, only: %i[new show create update destroy]

      resources :sites, only: %i[index show create update destroy] do
        scope module: :sites do
          resources :contracts, only: %i[index new create destroy] do
            collection do
              get "stats"
            end
          end

          resources :reports, only: [] do
            collection do
              get "online_users"
              get "popular_pages"
              get "devices"
              get "activities"
              get "geo"
              get "referrers"
              get "retention_rate"
              get "trends"
            end
          end

          resources :real_reports, only: [] do
            collection do
              get "online_users"
              get "popular_pages"
              get "devices"
              get "activities"
              get "geo"
              get "referrers"
              get "retention_rate"
              get "trends"
            end
          end
        end
      end

      get "me", to: "home#me"
      root to: "home#index"
    end

    namespace :client_v1 do
      root to: "home#index"

      get "me", to: "home#me"
      get "dashboard", to: "home#dashboard"
      get "stats", to: "home#stats"

      resources :sites, only: %i[show index] do
        scope module: :sites do
          resources :page_views, only: %i[index] do
            collection do
              delete "/", action: "batch_destroy"
            end
          end
          resources :contracts, only: %i[index new create destroy] do
            collection do
              get "stats"
            end
          end
        end
      end
    end
  end
end
