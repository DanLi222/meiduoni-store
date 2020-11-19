Rails.application.routes.draw do
  get 'activity/mine'
  get 'activity/feed'
  root to: 'activity#mine'
end
