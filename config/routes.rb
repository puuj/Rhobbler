Rhobbler2::Application.routes.draw do
  resources :users
  root :to => 'users#index'
end
