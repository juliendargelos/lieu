Rails.application.routes.draw do

  root to: 'home#index'

  resources :books, only: [:index, :update]

  get 'library' => 'library#index', as: :library

  scope :account do
    get '/' => 'users#show', as: :user
    get '/edit' => 'users#edit', as: :edit_user
    patch '/edit' => 'users#update', as: :users
    get '/destroy' => 'users#destroy', as: :destroy_user
  end

  get 'signup' => 'users#new', as: :new_user
  post 'signup' => 'users#create', as: :create_user

  get 'signin' => 'user/authentications#new', as: :new_user_authentication
  post 'signin' => 'user/authentications#create', as: :user_authentications
  get 'signout' => 'user/authentications#destroy', as: :destroy_user_authentication
end
