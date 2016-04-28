Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: 'application#main'
  get '/3d', to: 'application#three_d'
  get '/2d', to: redirect('/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
