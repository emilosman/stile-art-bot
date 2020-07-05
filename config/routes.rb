Rails.application.routes.draw do
  default_url_options :host => "localhost:3000"

  resources :boards do
    member do
      get 'items'
    end
  end

  resources :items

  get 'b/:id', to: 'boards#share'
  root to: 'boards#index'
end
