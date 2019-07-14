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
  match '/users/:id/update_balance',     to: 'users#update_balance',       via: 'post'
  match '/users/:id/purchase_image',     to: 'users#purchase_image',       via: 'post'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
