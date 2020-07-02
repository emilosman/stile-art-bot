Rails.application.routes.draw do
  default_url_options :host => "localhost:3000"

  resources :boards do
    member do
      get 'items'
    end
  end

  resources :items

  root to: 'boards#index'
end
