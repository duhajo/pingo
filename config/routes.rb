Duhajo::Application.routes.draw do

  get 'places/index'

  devise_for :users, :controllers => { :sessions => 'users/sessions', :registrations => 'users/registrations' }

  resources :searches, :only => [:index]

  resources :users do
    collection do
      get :autocomplete_user
      get :tag
    end
    resources :comments
  end

  resources :conversations do
    resources :messages
  end

  resources :pins do
    collection do
      get :autocomplete_pin_title
      get :tag
    end
  end
  resources :tags

  resources :places

  match 'dashboard' => 'dashboard#index'

  match 'pins/:pin_id/conversations/:c_id' => 'conversations#show_pin_conversation'

  match 'pins/new/:type' => 'pins#new'

  match 'pins/:id/new/:type' => 'pins#new', :as => 'new_sub_pin'
  match 'pins/:id/support' => 'pins#support'
  match 'pins/:id/set_status' => 'pins#set_status'
  match 'pins/:id/map_for_pin' => 'pins#map_for_pin'
  match 'pins/:id/show_manager_list' => 'pins#show_manager_list', :as => 'show_manager_list'
  match 'pins/:id/edit_manager_list' => 'pins#edit_manager_list'

  match 'pins/:id/conversation/:conversation_id' => 'conversation#show'

  match 'pins/:id/new_file' => 'pins#new_file'

  put 'pins/:id/like' => 'pins#like', :as => 'like_pin'

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
    get '/login', :to => 'users/sessions#new', :as => :login
    post '/users/create', :to => 'users/sessions#create', :as => :user_session
    get '/logout', :to => 'users/sessions#destroy', :as => :logout
    get '/myprofile', :to => 'users#my_profile', :as => :myprofile
  end

  root :to => 'pins#index'
  authenticate :user do
    root :to => 'dashboard#index'
  end


  # See how all your routes lay out with 'rake routes'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
