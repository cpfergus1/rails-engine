# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/merchants/find_all', to: 'merchants#find_all'
      get '/merchants/most_revenue', to: 'merchants#most_revenue'
      get '/merchants/most_items', to: 'merchants#most_items'
      get '/revenue', to: 'merchants#revenue'
      get '/merchants/:id/revenue', to: 'merchants#revenue'
      resources :merchants do
        scope module: 'merchants' do
          resources :items, only: [:index]
        end
      end
      get '/items/find', to: 'items#find'
      get '/items/find_all', to: 'items#find_all'
      resources :items do
        scope module: 'items' do
          resources :merchants, only: [:index]
        end
      end
    end
  end
end
