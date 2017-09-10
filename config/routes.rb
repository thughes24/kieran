Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "home#index" 
  resources :tips, only: [:index,:create,:destroy,:update]
  match "/refresh_odds", to: "odds#refresh_odds", via: :get
  #match "/meeting", to: "test#meeting", via: :get
  resources :users, only: [:new, :create, :show, :update]
  match "/send_tips", to: "users#send_tips", via: :get
  resources :meetings, only: [:show]
  resources :sessions, only: [:create, :destroy]
end
