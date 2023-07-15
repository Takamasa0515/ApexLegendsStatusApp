Rails.application.routes.draw do
  devise_for :users
  root 'top#index'
  resources :users, only: %i[index show] do
    collection do
      get 'search'
    end
  end
  resources :game_account_info, only: %i[edit update]
end
