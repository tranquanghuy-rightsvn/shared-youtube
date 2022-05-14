Rails.application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
  }

  resources :videos, only: [:new, :create] do 
    member do
      post :reaction
    end
  end

  match '*path', :to => 'application#redirect_to_root_path', via: [:get, :post]
end
