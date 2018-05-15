Rails.application.routes.draw do
  resource :user, path: :account, except: [:index, :show]
  resources :explanations

  resources :books, only: [:index, :show] do
    resources :chapters, only: :index
  end

  resource :authentication, only: [:new, :create], path: '/', path_names: { new: '/' }, module: :user, as: :user_authentication do
    get 'logout' => 'authentications#destroy', as: :destroy
  end

  root to: 'user/authentications#new'
end
