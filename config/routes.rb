Rails.application.routes.draw do
  default_url_options :only_path => true
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :api do
    resources :boards
  end

  resources :boards, except: [:show] do
    member do
      get 'items'
      post 'download'
    end
  end

  resources :items

  get 'b/:id', to: 'boards#share', as: :share
  root to: 'boards#index'
end
