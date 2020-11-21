Rails.application.routes.draw do
  devise_for :users
  get 'activity/mine'
  get 'activity/feed'
  root to: 'products#index'
  resources :products
  namespace :admins do
    resources :products
  end

end
