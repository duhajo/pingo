Duhajo::Application.routes.draw do

  get "places/index"

  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations" }

  resources :searches, :only => [:index]

  resources :activities

  match "worker/:id" => "users#show", :as => 'worker'

  resources :users do
    collection do
      get :autocomplete_user
      get :tag
    end
    resources :comments
  end

  resources :jobs do
    collection do
      get :autocomplete_job_title
      get :tag
    end
    resources :comments, only: [:create, :reply, :update, :edit, :destroy] do
      match "reply" => "comments#reply"
    end
  end
  resources :tags
  
  resources :places

  match "dashboard" => "dashboard#index"

  match "jobs/new/:type" => "jobs#new"
  
  match "jobs/:id/new" => "jobs#new", :as => 'new_subjob'
  match "jobs/:id/support" => "jobs#support"
  match "jobs/:id/love" => "jobs#like", :as => 'love_job'
  match "jobs/:id/set_status" => "jobs#set_status"
  match "jobs/:id/map_for_job" => "jobs#map_for_job"
  match "jobs/:id/show_manager_list" => "jobs#show_manager_list", :as => "show_manager_list"
  match "jobs/:id/edit_manager_list" => "jobs#edit_manager_list"
  
  match "jobs/:id/new_file" => "jobs#new_file"

  put 'jobs/:id/like' => 'jobs#like', :as => 'like_job'

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products

  devise_scope :user do
    get "/login", :to => "users/sessions#new", :as => :login
    post "/users/create", :to => "users/sessions#create", :as => :user_session
    get "/logout", :to => "users/sessions#destroy", :as => :logout
    get "/myprofile", :to => "users#my_profile", :as => :myprofile
  end

  root :to => "jobs#index"
  authenticate :user do
    root :to => "dashboard#index"
  end


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
