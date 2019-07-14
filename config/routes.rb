Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#home'

  get '/.well-known/acme-challenge/b3uOjES-NWjtHUpEZdyC_xIk_UOO4S7bT938YTSD1qQ', to: 'entries#encrypt'

  # Routes for Google authentication
  get 'auth/google_oauth2/callback', to: 'sessions#google_auth'
  get 'auth/failure', to: redirect('sessions/new')

  resources :users do
    resources :goals, only: %i(index)

    resources :wallets, only: %i(index new create edit update)
  end

  resources :wallets do
    resources :sharings, only: %i(new create destroy)
  end

  resources :goals, only: %i(edit show destroy)

  resources :sessions, only: %i(create)
  get    '/login',  to: 'sessions#new',     as: 'login'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get   '/users/:user_id/search',   to: 'entries#search',   as: 'search'

  resources :entries, only: %i(new create)
  post '/entry/expenses', to: 'entries#create'
  post '/entry/revenues', to: 'entries#create'

  get   '/users/:user_id/expenses', to: 'entries#expenses', as: 'expenses'
  get   '/users/:user_id/revenues', to: 'entries#revenues', as: 'revenues'
  patch '/entries/:id',             to: 'entries#update',   as: 'entry_revenue'
  patch '/entries/:id',             to: 'entries#update',   as: 'entry_expense'
  put   '/entries/:id',             to: 'entries#update'
  put   '/entries/:id',             to: 'entries#update'

  get    '/entries/:id',              to: 'entries#show',         as: 'entry'
  get    '/entries/:id/installments', to: 'entries#installments', as: 'installments'
  get    '/entries/:id/edit',         to: 'entries#edit',         as: 'edit_entry'
  get    '/users/:user_id/entries',   to: 'entries#index',        as: 'dashboard'
  delete '/entries/:id',              to: 'entries#destroy',      as: 'delete_entry'
end
