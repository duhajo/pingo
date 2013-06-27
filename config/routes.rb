Duhajo::Application.routes.draw do

  match '/signup', :to => 'users#new'
  match '/myprofile', :to => 'users#my_profile'
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'

  resources :activities
  resources :users do
    collection do
      get :tag
    end
    resources :activities
  end
  resources :sessions, :only => [:new, :create, :destroy]
  resources :jobs do
    collection do
      get :tag
    end
    resources :activities do
      resources :activities
    end
  end
  
  match "jobs/:id/new" => "jobs#new"
  match "jobs/:id/support" => "jobs#support"


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
  root :to => 'dashboard#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
