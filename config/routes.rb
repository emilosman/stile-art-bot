Rails.application.routes.draw do
  if Rails.env.production?
    default_url_options :host => "moonboardapp.herokuapp.com"
  else
    default_url_options :only_path => true
  end

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
