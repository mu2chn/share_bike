Rails.application.routes.draw do
  root to: 'root#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/new',  to: 'users#new', as: 'u-new'
  post '/users/create', to: 'users#create', as: 'u-create'
  get '/users/show/:id', to: 'users#show'
  get '/users/edit', to: 'users#edit', as: 'u-edit'
  patch '/users/update', to: 'users#update', as: 'u-update'

  get '/tourists/new', to: 'tourists#new', as: 't-new'
  post '/tourists/create', to: 'tourists#create', as: 't-create'
  get '/tourists/edit', to: 'tourists#edit', as: 't-edit'
  patch '/tourists/update', to: 'tourists#update', as: 't-update'

  get '/bikes', to: 'bikes#index', as: 'b-index'
  get '/bikes/show/:id', to: 'bikes#show', as: 'b-show'
  post '/bikes/rent/:id', to: 'bikes#rent', as: 'b-rent'

  get '/bikes/new', to: 'bikes#new', as: 'b-new'
  post '/bikes/create', to: 'bikes#create', as: 'b-create'
  #get '/bikes/mine', to: 'bikes#mine', as: 'b-mine'
  #get '/bikes/edit', to: 'bikes#edit', as: 'b-edit'

  get '/u-login',   to: 'sessions#u_new', as: 'u-login'
  get '/t-login', to: 'sessions#t_new', as: 't-login'
  post '/login',   to: 'sessions#create', as: 'login'
  get '/logout',  to: 'sessions#destroy', as: 'logout'

end
