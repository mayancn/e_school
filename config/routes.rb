Rails.application.routes.draw do
  root "welcomes#index"
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: {invitations: "invitations", registrations: "admin/registrations"}

  namespace :admin do
    resources :quizzes do
      resources :questions, only: :new
    end
    resources :questions, except: :new
    resources :xlquizzes
    resources :groups
    get '/analyze/:quiz_id', to: 'quizzes#analyze', as: :analyze
    get '/assignevaluators/:quiz_id', to: 'quizzes#assign_evaluators', as: :assign_evaluators
    get 'evaluatequiz/:quiz_id', to: 'quizzes#evaluate_quiz', as: :evaluate_quiz
    get '/downloadtemplate', to: 'xlquizzes#download_template', as: :download_template
    get '/addusers/:group_id', to: 'groups#add_users', as: :addusers
    match 'publishquiz/:quiz_id', to: 'quizzes#publish_quiz', as: :publish_quiz, via: [:get, :post, :put, :patch]
  end

  resources :quizzes
  resources :questions
  resources :solve_questions
  resources :results
  resources :users do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :unlocks, controller: 'rails_jwt_auth/unlocks', only: %i[update]
  # resources :invitations, controller: 'rails_jwt_auth/invitations', only: [:create, :update]
  # resources :passwords, controller: 'rails_jwt_auth/passwords', only: [:create, :update]
  # resources :confirmations, controller: 'rails_jwt_auth/confirmations', only: [:create, :update]
  # resource :registrations, controller: 'rails_jwt_auth/registrations', only: [:create]
  # resource :sessions, controller: 'rails_jwt_auth/sessions', only: [:create, :destroy]
  
  #API
  namespace :api do
    namespace :v1 do
      # mount_devise_token_auth_for 'User', at: 'auth'
      resources :questions, except: :show
      resources :quizzes do
        resources :questions, only: :show
      end
      resources :results
      resources :solve_questions
      resources :sessions, only: [:create, :destroy]
      resources :registrations, only: [:create, :destroy]
    end
  end

  #Customized routes
  post :next_question, to: 'questions#next', as: :next_question
  get :previous_question, to: 'questions#previous', as: :previous_question
  match '/togglestatus/:user_id', to: 'users#toggle_status', as: :toggle_status, via: [:get, :post, :put, :patch]
  get '/registered', to: 'users#registered', as: :registered
  match 'evaluatequestion/:user_id/:quiz_id', to: 'questions#evaluate_question', as: :evaluate_question, via: [:get, :post, :put, :patch]
end
