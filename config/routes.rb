Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  resources :users
  get 'signup' => 'users#new'

  get 'password_resets/new'
  get 'password_resets/edit'
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

end
