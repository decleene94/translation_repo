Rails.application.routes.draw do
  get '/posts', to: 'application#index', as: 'posts'
end
