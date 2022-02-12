Rails.application.routes.draw do
  resources :requests
  resources :projects
  resources :work_breakdown_structures
  resources :payment_methods
  devise_for :accounts, controllers: {
    sessions: 'accounts/sessions'
  }
  devise_scope :account do
    root to: 'accounts/sessions#new'
    get 'sign_in', to: 'accounts/sessions#new'
    get '/accounts/sign_out', to: 'accounts/sessions#destroy'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
