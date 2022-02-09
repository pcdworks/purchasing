Rails.application.routes.draw do
  resources :requests
  resources :projects
  resources :work_breakdown_structures
  resources :payment_methods
  devise_for :accounts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
