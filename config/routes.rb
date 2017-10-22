Rails.application.routes.draw do
  resources :forecasts, only: :index do
    get :retrieve, on: :collection
  end

  root 'forecasts#index'
end
