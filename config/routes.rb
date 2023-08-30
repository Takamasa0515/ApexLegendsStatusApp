Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root 'top#index'

  resources :users, only: %i[index show destroy] do
    collection do
      get 'search'
    end
    resources :tracker_match_records, only: %i[index show]
    post "tracker_match_records", to: "tracker_match_records#show_records", as: "tracker_show_records"
  end

  resources :game_account_info, only: %i[edit update]

  resources :contacts, only: %i[new create]

  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  post 'contacts/back', to: 'contacts#back', as: 'back'
  get 'complete', to: 'contacts#complete', as: 'complete'
end
