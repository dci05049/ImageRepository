Rails.application.routes.draw do
  root 'image#index'
  post 'image/store' => 'image#store'
  delete 'image/destroy/:id' => 'image#destroy'

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  
  devise_for :users
  resource :users

  match '/users',   to: 'users#index',   via: 'get'
  match '/users/:id',     to: 'users#show',       via: 'get'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
