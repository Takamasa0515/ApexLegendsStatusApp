Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  root 'top#index'
  resources :users, only: %i[index show] do
    collection do
      get 'search'
    end
  end
  resources :game_account_info, only: %i[edit update]
end
