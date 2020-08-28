Rails.application.routes.draw do
  root 'room#main'
  resources :rooms
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
