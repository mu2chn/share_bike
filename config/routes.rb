Rails.application.routes.draw do
  root to: 'root#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/signup',  to: 'users#new'
  get '/users/show/:id', to: 'users#show'
  post '/users/create', to: 'users#create'
  post '/users/update', to: 'users#update'

  get '/u-login',   to: 'sessions#u_new'
  get '/t-login', to: 'sessions#t_new'
  post '/login',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'
end
