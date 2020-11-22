Rails.application.routes.draw do
  devise_for :users
  root 'rooms#main'
  resources :rooms

  get '/secret/:id' => 'rooms#secret'
  post '/passcheck/:id' => 'rooms#passCheck'
  post '/search' => 'rooms#search'

  delete '/roomquit' => 'rooms#roomquit'

  get '/chat' => 'chat#index'
  get 'help' => 'rooms#help', as: :help
  post '/startGame' => 'rooms#startGame', as: :startGame

  get '/result/:id/:winner_id' => 'rooms#result', as: :result
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
