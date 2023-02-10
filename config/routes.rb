Rails.application.routes.draw do
  get 'reports', to: 'reports#index'
  get 'reports/builder'
  get 'reports/payment_method_results'
  get 'reports/itemized_requests_results'
  get 'reports/summarized_requests_results'
  resources :items, only: [:update]
  get 'pages/browsers'
  get 'work_breakdown_structures', to: 'pages#work_breakdown_structures'
  resources :requests, param: :identifier
  resources :projects
  resources :payment_methods
  devise_for :accounts, controllers: {
    sessions: 'accounts/sessions'
  }
  devise_scope :account do
    root to: 'accounts/sessions#new'
    get 'sign_in', to: 'accounts/sessions#new'
    get '/accounts/sign_out', to: 'accounts/sessions#destroy'
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
