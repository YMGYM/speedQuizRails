Rails.application.routes.draw do
  devise_for :users
  root 'rooms#main'
  resources :rooms

  get '/secret/:id' => 'rooms#secret'
  post '/passcheck/:id' => 'rooms#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
