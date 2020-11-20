Rails.application.routes.draw do
  get 'activity/mine'
  get 'activity/feed'
  root to: 'products#index'
  resources :products
end
