Rails.application.routes.draw do
  get '/posts', to: 'application#index'
  get '/posts/:id', to: 'application#show'
  post '/posts', to: 'application#create'
end
