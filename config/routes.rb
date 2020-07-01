Rails.application.routes.draw do
  resources :boards
  resources :items

  root to: 'boards#index'
end
