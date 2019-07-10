Rails.application.routes.draw do

  root 'static_pages#home'

  # Sessions
  get    '/login',         to: 'sessions#new'
  post   '/login',         to: 'sessions#create'
  delete '/logout',        to: 'sessions#destroy'

  get 'auth/:provider/callback', to: 'sessions#create_with_auth'
  get 'auth/failure',            to: redirect('/login')

  # Static Pages
  get '/signup',  to: 'static_pages#signup'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

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
  get 'courses/delete', to: 'courses#destroy'
  resources :courses do
    member do
      delete :delete_image
    end
  end

  # Lessons
  get 'lessons/new'
  get 'lessons/create'
  get 'lessons/edit'
  get 'lessons/update'
  get 'lessons/delete', to: 'lessons#destroy'
  resources :lessons do
    member do
      delete :delete_video
      delete :delete_resource
    end
    collection do
      patch :sort
    end
  end

  # Subscriptions
  get    '/subscribe',   to: 'subscriptions#new'
  post   '/subscribe',   to: 'subscriptions#create'
  get    '/unsubscribe', to: 'subscriptions#destroy'
  delete '/unsubscribe', to: 'subscriptions#destroy'
  resources :subscriptions, only: [:create, :destroy]

  # Forum
  resources :messages, only: [:create, :destroy]
  resources :posts, only: [:create, :destroy]

  # Videos
  get 'videos/index'
  get 'videos/new'
  get 'videos/create'
  resources :videos, only: [:index, :new, :create, :destroy]

  # Account-activation
  resources :account_activations, only: [:edit]

  # Password-reset
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Reviews
  resources :reviews, only: [:create, :destroy, :index, :update]

  # Notifications
  delete 'notifications/clear'
  resources :notifications, only: :destroy

  # Reports
  resources :reports, only: :create
end
