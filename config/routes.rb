Rails.application.routes.draw do
  get 'pages/browsers'
  get 'work_breakdown_structures', to: 'pages#work_breakdown_structures'
  resources :requests do
    get :send_mail, to: 'requests#send_mail'
  end
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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
