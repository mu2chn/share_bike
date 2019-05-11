Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/signup',  to: 'users#new'
  get '/users/show/:id', to: 'users#show'
  #get '/users/edit/:id', to: 'users#edit'
  post '/users/create', to: 'users#create'
  post '/users/update', to: 'users#update'
end
