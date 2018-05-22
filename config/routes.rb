Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#home'

  namespace :api do
    resources :users, only: [] do
      resources :goals,   only: %i(index create)
      resources :entries, only: %i(index create)

      get '/entries/expense', to: 'entries#index', type: 'expense'
      get '/entries/revenue', to: 'entries#index', type: 'revenue'

      get '/entries/by_month', to: 'entries#entries_by_month'

      get '/balance', to: 'entries#balance'
      get '/balance/monthly', to: 'entries#monthly_balance'
      get '/expense/monthly', to: 'entries#monthly_expense'
      get '/revenue/monthly', to: 'entries#monthly_revenue'

      get '/balance/weekly', to: 'entries#weekly_balance'
      get '/expense/weekly', to: 'entries#weekly_expense'
      get '/revenue/weekly', to: 'entries#weekly_revenue'

      get '/balance/daily', to: 'entries#daily_balance'
      get '/expense/daily', to: 'entries#daily_expense'
      get '/revenue/daily', to: 'entries#daily_revenue'

      get '/expense/by_category', to: 'entries#expense_by_category'
      get '/revenue/by_category', to: 'entries#revenue_by_category'
    end
    resources :goals, only: %i(update) do
      get '/expenses', to: 'entries#list'
    end
    get '/categories', to: 'categories#index'

    put  '/users/:id/redefine',     to: 'users#redefine'
  end

  resources :users, only: %i(create) do
    resources :goals, only: %i(index)
  end
  resources :goals, only: %i(edit show destroy)
  get  '/signup',                 to: 'users#new',               as: 'signup'
  get  '/users/:id/confirmation', to: 'users#confirm',           as: 'confirmation'
  get  '/recover',                to: 'users#recover',           as: 'recover_password'
  post '/recover',                to: 'users#send_email_for_recover'
  get  '/users/:id/redefine',     to: 'users#redefine_password', as: 'redefine_password'
  put  '/users/:id/redefine',     to: 'users#redefine',          as: 'redefine'

  resources :sessions, only: %i(create)
  get    '/login',  to: 'sessions#new',     as: 'login'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get   '/users/:user_id/search',   to: 'entries#search',   as: 'search'

  get   '/users/:user_id/expenses', to: 'entries#expenses', as: 'expenses'
  get   '/users/:user_id/revenues', to: 'entries#revenues', as: 'revenues'
  post  '/users/:user_id/revenues', to: 'entries#create',   as: 'entry_revenues'
  post  '/users/:user_id/expenses', to: 'entries#create',   as: 'entry_expenses'
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
