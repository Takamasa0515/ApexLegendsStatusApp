Rails.application.routes.draw do
  devise_for :users
  root 'top#index'
  resources :users, only: :show
  resources :game_account_info, only: %i[edit update]
end
