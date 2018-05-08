Rails.application.routes.draw do
  # get 'books/index'
  root to: 'dashboard#index'

  resources :books

  scope :account do
    get '/' => 'users#show', as: :user
    get '/edit' => 'users#edit', as: :edit_user
    patch '/edit' => 'users#update'
    get '/destroy' => 'users#destroy', as: :destroy_user
  end

  get 'signup' => 'users#new', as: :new_user
  post 'signup' => 'users#create', as: :users

  get 'signin' => 'user/authentications#new', as: :new_user_authentication
  post 'signin' => 'user/authentications#create', as: :user_authentications
  get 'signout' => 'user/authentications#destroy', as: :destroy_user_authentication
end
