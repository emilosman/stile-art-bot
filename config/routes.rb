Rails.application.routes.draw do
  default_url_options :only_path => true

  namespace :api do
    resources :boards
  end

  resources :boards, except: [:show] do
    member do
      get 'items'
    end
  end

  resources :items

  get 'b/:id', to: 'boards#share', as: :share
  root to: 'boards#index'
end
