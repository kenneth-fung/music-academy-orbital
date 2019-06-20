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

  # Videos
  get 'videos/index'
  get 'videos/new'
  get 'videos/create'
  resources :videos, only: [:index, :new, :create, :destroy]

  # Account-activation
  resources :account_activations, only: [:edit]

  # Password-reset
  resources :password_resets, only: [:new, :create, :edit, :update]
end
