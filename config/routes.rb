Rails.application.routes.draw do

  resources :clearance_batches, only: [:index, :create, :show]

  resources :items, only: [:index]

  root "application#index"

end
