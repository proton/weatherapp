Rails.application.routes.draw do
  resources :forecasts, only: :index

  root 'forecasts#index'
end
