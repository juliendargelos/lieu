Rails.application.routes.draw do
  resources :books, only: :index
  resources :readings, only: [:show, :create, :update]
  resource :user, path: :account, only: [:new, :edit, :create, :update, :destroy]
  resource :avatar, only: [:new, :edit, :create, :update]
  resource :draw, only: :create
  resource :emoji, only: :create
  resource :explanations, only: :show
  resource :dashboard, only: :show, controller: :dashboard

  resource :authentication, only: [:new, :create], path: '/', path_names: { new: '/' }, module: :user, as: :user_authentication do
    get 'logout' => 'authentications#destroy', as: :destroy
  end

  root to: 'user/authentications#new'
end
