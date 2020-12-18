Rails.application.routes.draw do
  devise_for :users
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

  get 'add_line_item' => 'line_items#add_line_item'
  get 'add_address' => 'addresses#add_address'
  get 'checkout' => 'checkout#checkout'
  get 'update_billing_address' => 'checkout#update_billing_address'

end
