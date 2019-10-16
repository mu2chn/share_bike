Rails.application.routes.draw do
  root to: 'root#index'

  get '/root/about', to: 'root#about', as:'about'
  get '/root/first', to: 'root#first', as:'first'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/new',  to: 'users#new', as: 'u-new'
  post '/users/create', to: 'users#create', as: 'u-create'
  get '/users/show/:id', to: 'users#show', as: 'u-show'
  get '/users/edit', to: 'users#edit', as: 'u-edit'
  patch '/users/update', to: 'users#update', as: 'u-update'
  get '/users/reserve', to: 'users#reserve', as: 'u-reserve'

  post '/reserve', to: 'tourist_bikes#reserve', as: 'reserve'
  delete '/reserve/delete/:id', to: 'tourist_bikes#delete', as: 'r-delete'
  post '/reserve/accept/:id', to: 'tourist_bikes#accept', as: 'r-accept'
  get '/reserve/payment/:id', to:'tourist_bikes#payment', as: 'r-payment'
  post '/reserve/check', to: 'payment_api#check', as: 'r-check'
  post '/reserve/unpaid', to: 'payment_api#unpaid', as: 'r-unpaid'
  get '/t', to: 'payment_api#test'

  get '/tourists/new', to: 'tourists#new', as: 't-new'
  post '/tourists/create', to: 'tourists#create', as: 't-create'
  get '/tourists/edit', to: 'tourists#edit', as: 't-edit'
  patch '/tourists/update', to: 'tourists#update', as: 't-update'
  get 'tourists/reserve', to: 'tourists#reserve', as: 't-reserve'

  get '/bikes', to: 'bikes#index', as: 'b-index'
  get '/bikes/show/:id', to: 'bikes#show', as: 'b-show'
  post '/bikes/rent/:id', to: 'bikes#rent', as: 'b-rent'

  get '/bikes/new', to: 'bikes#new', as: 'b-new'
  post '/bikes/create', to: 'bikes#create', as: 'b-create'
  get '/bikes/edit/:id', to: 'bikes#edit', as: 'b-edit'
  patch '/bikes/update/:id', to: 'bikes#update', as: 'b-update'

  get '/u-login',   to: 'sessions#u_new', as: 'u-login'
  get '/t-login', to: 'sessions#t_new', as: 't-login'
  post '/login',   to: 'sessions#create', as: 'login'
  get '/logout',  to: 'sessions#destroy', as: 'logout'

end
