Rails.application.routes.draw do
  root to: 'products#index'
  
  scope "/:locale" do
    devise_for :users, :controllers => {:registrations => "registrations"}

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
end
