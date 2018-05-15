Rails.application.routes.draw do

  resources :explanations
  resources :books, only: [:index, :show] do
    resources :chapters, only: :index
  end

  scope :account do
    get '/' => 'users#show', as: :user
    get 'edit' => 'users#edit', as: :edit_user
    patch 'edit' => 'users#update'
    get 'destroy' => 'users#destroy', as: :destroy_user
  end

  get 'signup' => 'users#new', as: :new_user
  post 'signup' => 'users#create', as: :users

  root to: 'user/authentications#new'
  get '/' => 'user/authentications#new', as: :new_user_authentication
  post '/' => 'user/authentications#create', as: :user_authentications
  get 'logout' => 'user/authentications#destroy', as: :destroy_user_authentication
end
