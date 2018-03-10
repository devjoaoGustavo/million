Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#home'

  resources :users, only: %i[create]
  get '/signup', to: 'users#new', as: 'signup'
  get '/users/:id/confirmation', to: 'users#confirm', as: 'confirmation'

  resources :sessions, only: %i[create]
  get    '/login',  to: 'sessions#new',     as: 'login'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get '/users/:user_id/expenses',  to: 'entries#expenses', as: 'expenses'
  get '/users/:user_id/revenues',  to: 'entries#revenues', as: 'revenues'

  get    '/users/:user_id/entries', to: 'entries#index',   as: 'dashboard'
  post   '/users/:user_id/entries', to: 'entries#create',  as: 'entries'
  delete '/entries/:id',            to: 'entries#destroy', as: 'delete_entry'
end
