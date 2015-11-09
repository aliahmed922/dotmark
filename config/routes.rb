Rails.application.routes.draw do
  # constraints :subdomain => /.+/ do
    devise_for :students, controllers: { registrations: "students/registrations", sessions: "students/sessions", confirmations: "students/confirmations" }
    devise_scope :student do
      get "students/login" => "students/sessions#new", as: :students_login
      get "students/login_after_confirmation" => "students/sessions#login_after_confirmation", as: :students_login_after_confirmation
      get "students/admissions/:batch_name" => "students/registrations#new", as: :new_admissions
      post "/cancel_admission" => "students/registrations#cancel_admission"
      post "/setup_admission" => "students/registrations#setup_admission", as: :setup_admissions
      get "/autocomplete_guardians_search" => "students/registrations#autocomplete_guardians_search"
      get "/get_parent/:parent_id" => "students/registrations#get_parent"
    end
  # end

  authenticated :student do
    root 'students#dashboard', as: :student_authenticated_root
  end
  resources :students, only: [:index]


  devise_for :parents

  constraints :subdomain => "admin" do 
    devise_for :admins, controllers: { sessions: "admins/sessions" }
    devise_scope :admin do
      get "/login" => "admins/sessions#new", as: :admin_login
    end
    authenticated :admin do
      root 'admins#dashboard', as: :admin_authenticated_root
    end
  end


  namespace :institutes do
    resources :batches, only: [:index, :create, :destroy] do
      put "/add_sections" => "batches#add_sections", as: :add_sections
    end
    resources :sections, only: [:index, :update, :destroy]

    get "/get_sections" => "base#get_sections", as: :get_sections

    resources :classrooms
    resources :courses
  end

  get "/about_us" => "landings#about"
  root to: "landings#home"
  
end
