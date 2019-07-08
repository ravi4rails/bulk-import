Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  resources :policies
  resources :companies
  resources :employees
  root to: "home#index"

  get 'settings/new_import', to: 'settings#new_import'
  post 'settings/create_import', to: 'settings#create_import'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
