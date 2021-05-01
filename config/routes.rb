Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  get 'activity/mine'
  get 'activity/feed'
  root to: 'products#index'
  resources :products do
    resources :properties
    resources :inventories
  end
  namespace :admins do
    resources :products
    resources :properties
    resources :inventories
  end

  resources :carts
  resources :addresses

  get 'add_to_cart' => 'line_items#add_to_cart'
  get 'checkout' => 'checkout#checkout'
  post 'checkout' => 'checkout#checkout'
  get 'update_billing_address' => 'checkout#update_billing_address'
  post 'set_locale' => 'application#set_locale'
end
