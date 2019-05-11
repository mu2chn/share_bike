Rails.application.routes.draw do
  root to: 'root#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/signup',  to: 'users#new', as: 'u-signup'
  post '/users/create', to: 'users#create', as: 'u-create'
  get '/users/show/:id', to: 'users#show'
  get '/users/edit', to: 'users#edit', as: 'u-edit'
  post '/users/update', to: 'users#update'

  get '/tourists/signup', to: 'tourists#new', as: 't-signup'
  post '/tourists/create', to: 'tourists#create', as: 't-create'
  get '/tourists/edit', to: 'tourists#edit', as: 't-edit'
  post '/tourists/update', to: 'tourists#update'

  get '/bikes', to: 'bikes#index'
  get '/bikes/show/:id', to: 'bikes#show'
  post '/bikes/rent/:id', to: 'bikes#rent'

  get '/bikes/mine', to: 'bikes#mine'
  get '/bikes/edit', to: 'bike#edit'

  get '/u-login',   to: 'sessions#u_new', as: 'u-login'
  get '/t-login', to: 'sessions#t_new', as: 't-login'
  post '/login',   to: 'sessions#create', as: 'login'
  get '/logout',  to: 'sessions#destroy', as: 'logout'
end
