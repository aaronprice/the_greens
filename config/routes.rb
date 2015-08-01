Rails.application.routes.draw do

  resources :reservations
  resource :user, only: [:show] do
    resources :reservations, only: :destroy, controller: "users/reservations"
  end

  resources :sessions, only: [:new, :create, :destroy]
  get "/logout", to: "sessions#destroy", as: :logout

  root "reservations#index"
end
