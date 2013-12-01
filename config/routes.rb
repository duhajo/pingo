Duhajo::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations" }

  resources :searches, :only => [:index]
  resources :activities

  resources :users do
    collection do
      get :tag
    end
    get :autocomplete_user, :on => :collection
    resources :comments
  end

  resources :jobs do
    collection do
      get :tag
    end
    resources :comments, only: [:create, :reply, :update, :edit, :destroy] do
      match "reply" => "comments#reply"
    end
  end
  resources :tags

  match "dashboard" => "dashboard#index"

  match "jobs/:id/new" => "jobs#new"
  match "jobs/:id/support" => "jobs#support"
  match "jobs/:id/set_status" => "jobs#set_status"
  match "jobs/:id/map_for_job" => "jobs#map_for_job"
  match "jobs/:id/show_manager_list" => "jobs#show_manager_list"
  match "jobs/:id/edit_manager_list" => "jobs#edit_manager_list"
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
