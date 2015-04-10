Comable::Core::Engine.routes.draw do
  namespace :admin do
    root to: 'dashboard#show'

    resource :dashboard, only: :show

    resources :products do
      resources :stocks
    end
    resources :stocks

    resources :categories
    resources :orders
    resources :users
    resources :shipment_methods
    resources :payment_methods
    resource :store, controller: :store, only: [:show, :edit, :update]

    devise_for :user, path: :user, class_name: Comable::User.name, module: :devise, controllers: {
      sessions: 'comable/admin/user_sessions'
    }
  end
end
