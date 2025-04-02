Rails.application.routes.draw do
  root "tasks#index"  # Default homepage
  resources :tasks do
    member do
      patch :change_status
    end
  end
end
