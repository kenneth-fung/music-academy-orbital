Rails.application.routes.draw do

  # Sessions
  get    '/student_login', to: 'sessions#new_student'
  post   '/student_login', to: 'sessions#create_student'
  delete '/logout',        to: 'sessions#destroy'
  get    '/tutor_login',   to: 'sessions#new_tutor'
  post   '/tutor_login',   to: 'sessions#create_tutor'

  # Static Pages
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  root 'static_pages#home'

  # Tutors
  get  '/tutor_signup', to: 'tutors#new'
  post '/tutor_signup', to: 'tutors#create'
  resources :tutors do
    member do
      get :students, :courses
    end
  end

  # Students
  get  '/student_signup', to: 'students#new'
  post '/student_signup', to: 'students#create'
  resources :students do
    member do
      get :courses
    end
  end

  # Courses
  resources :courses

  # Subscriptions
  get    '/subscribe',   to: 'subscriptions#new'
  post   '/subscribe',   to: 'subscriptions#create'
  get    '/unsubscribe', to: 'subscriptions#destroy'
  delete '/unsubscribe', to: 'subscriptions#destroy'
  resources :subscriptions, only: [:create, :destroy]

  # Videos
  get 'videos/index'
  get 'videos/new'
  get 'videos/create'
  resources :videos, only: [:index, :new, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
