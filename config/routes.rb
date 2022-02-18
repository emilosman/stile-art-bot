Rails.application.routes.draw do
  default_url_options only_path: false
  default_url_options host: "localhost:3000" if Rails.env.development?
  default_url_options host: "https://stile-art-bot.herokuapp.com" if Rails.env.production?
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions' }

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
