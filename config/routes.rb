Rails.application.routes.draw do
  root "assets#index"

  get  "login",  to: "sessions#new",     as: :login
  post "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :users
  resources :locations

  resources :asset_classes do
    resources :asset_class_characteristics, only: [:create, :destroy]
  end

  resources :characteristics do
    resources :characteristic_allowed_values, only: [:create, :destroy]
  end

  resources :assets, path: "register" do
    member do
      get  :characteristic_values
      patch :characteristic_values, action: :update_characteristic_values
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
