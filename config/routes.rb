Rails.application.routes.draw do
  resource :user, path: :account, except: [:index, :show]
  # resource :avatar, path_names: { edit: '/' }, only: [:edit, :udpate]
  resources :avatars, only: :index
  resources :explanations
  resource :dashboard, only: :show
  resources :readings, only: [:show, :create, :update]
  resources :draws, only: [:show, :create]
  resources :chapters, only: :show

  resources :books, only: :index

  resource :authentication, only: [:new, :create], path: '/', path_names: { new: '/' }, module: :user, as: :user_authentication do
    get 'logout' => 'authentications#destroy', as: :destroy
  end

  root to: 'user/authentications#new'
end
