Rails.application.routes.draw do
  resources :timekeeping_records, only: [:index, :create]
end
