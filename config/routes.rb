Rails.application.routes.draw do
  resource :user, path: :account, except: [:index, :show]
  resources :avatars, only: [:index, :create]
  resources :explanations
  resource :dashboard, only: :show
  resources :readings, only: [:show, :create, :update]
  resources :draws, only: [:show, :create]
  resources :libraries, only: [:index]

  resources :books, only: :index

  resource :authentication, only: [:new, :create], path: '/', path_names: { new: '/' }, module: :user, as: :user_authentication do
    get 'logout' => 'authentications#destroy', as: :destroy
  end

  root to: 'user/authentications#new'
end
