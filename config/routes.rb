Rails.application.routes.draw do
  root "staticpages#top"
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: %i[new create]
  get 'login', to: 'user_session#new'
  post 'login', to: 'user_session#create'
  delete 'logout', to: 'user_session#destroy'
  get "up" => "rails/health#show", as: :rails_health_check
  resources :boards, only: %i[index]
  

end
