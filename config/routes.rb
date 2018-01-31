Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#home'

  resources :users, only: %i[create]
  get '/signup', to: 'users#new', as: 'signup'
  get '/users/:id/confirmation', to: 'users#confirm', as: 'confirmation'

  resources :sessions, only: %i[create]
  get    '/login',  to: 'sessions#new',     as: 'login'
  delete '/logout', to: 'sessions#destroy', as: 'logout'
end
