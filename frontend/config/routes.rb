Comable::Core::Engine.routes.draw do
  root to: 'home#show'

  resource :home, only: :show
  resources :products

  resource :cart do
    collection do
      # TODO: post => put
      post :add
      put :checkout
    end
  end

  resource :order, only: [:create] do
    collection do
      get 'signin', as: :signin
      put 'guest', as: :guest
      get ':state', action: :edit, as: :next
      put ':state', action: :update
    end
  end

  resources :pages, only: [:show]

  devise_for :users, path: :member, class_name: Comable::User.name, module: :devise, router_name: :comable

  resource :user, path: :member do
    member do
      get :addresses
      put :addresses, action: :update_addresses
    end
  end
end
