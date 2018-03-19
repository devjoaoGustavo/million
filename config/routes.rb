Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#home'

  resources :users, only: %i[create]
  get  '/signup',                 to: 'users#new',               as: 'signup'
  get  '/users/:id/confirmation', to: 'users#confirm',           as: 'confirmation'
  get  '/recover',                to: 'users#recover',           as: 'recover_password'
  post '/recover',                to: 'users#send_email_for_recover'
  get  '/users/:id/redefine',     to: 'users#redefine_password', as: 'redefine_password'
  put  '/users/:id/redefine',     to: 'users#redefine',          as: 'redefine'

  resources :sessions, only: %i[create]
  get    '/login',  to: 'sessions#new',     as: 'login'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get   '/users/:user_id/expenses', to: 'entries#expenses', as: 'expenses'
  get   '/users/:user_id/revenues', to: 'entries#revenues', as: 'revenues'
  post  '/users/:user_id/revenues', to: 'entries#create',   as: 'entry_revenues'
  post  '/users/:user_id/expenses', to: 'entries#create',   as: 'entry_expenses'
  patch '/entries/:id',             to: 'entries#update',   as: 'entry_revenue'
  patch '/entries/:id',             to: 'entries#update',   as: 'entry_expense'

  get    '/entries/:id',            to: 'entries#show',    as: 'entry'
  get    '/entries/:id/edit',       to: 'entries#edit',    as: 'edit_entry'
  get    '/users/:user_id/entries', to: 'entries#index',   as: 'dashboard'
  delete '/entries/:id',            to: 'entries#destroy', as: 'delete_entry'
end
