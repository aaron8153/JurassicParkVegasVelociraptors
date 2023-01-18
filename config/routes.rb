Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "dashboard#index"

  concern :api_base do
    resources :species
    resources :dinosaurs
    resources :cages
  end

  namespace :v1 do
    concerns :api_base
  end
end
