Comable::Core::Engine.routes.draw do
  namespace :admin do
    root to: 'products#index'

    resources :shipment_methods
    resources :stores
  end
end
