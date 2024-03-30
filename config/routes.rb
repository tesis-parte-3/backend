Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  get '/current', to: 'authentication#current'

  resources :exams do
    get "stats", on: :collection

  end 
  resources :users do
    get 'current', on: :collection
    post 'email_recovery', on: :collection
    post 'recovery_password', on: :collection
    put 'set_avatar', on: :collection
    post 'approve_exam', on: :collection
    post 'reprove_exam', on: :collection
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
