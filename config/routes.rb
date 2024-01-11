Rails.application.routes.draw do
  root "staticpages#top"
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: %i[new create]
  # resources :boards, only: %i[index new create destroy]
  get 'login', to: 'user_session#new'
  post 'login', to: 'user_session#create'
  delete 'logout', to: 'user_session#destroy'
  get "up" => "rails/health#show", as: :rails_health_check
  # 追加 新しいguest_majorレコードを作成する
  resources :guest_majors, only: [:create]
  # 追加 ランダムにboardを2つ選び、それらをJSON形式で返す
  get 'boards/random', to: 'boards#random_boards'
  get 'boards/which_major', to: 'boards#which_major'
  resources :boards do
    resource :majors, only: [:create, :destroy]
    resource :minors, only: [:create, :destroy]
  end
  
end
