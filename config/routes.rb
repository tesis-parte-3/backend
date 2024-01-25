Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  get '/current', to: 'authentication#current'
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
