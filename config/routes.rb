Rails.application.routes.draw do
  devise_for :users
  get 'activity/mine'
  get 'activity/feed'
  root to: 'products#index'
  resources :products do
    resources :properties
  end
  namespace :admins do
    resources :products
    resources :properties
  end

end
