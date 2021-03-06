Rails.application.routes.draw do

  resources :department_entry_memberships
  resources :department_entries do
    collection do
      post :fetch_users
    end
  end

  resources :favourites

  get 'notification_settings' => 'email_notification_settings#index', :as => :notification_settings
  get 'pending_approval' => 'pages#pending_approval', as: :pending_approval
  get 'dashboard' => 'pages#dashboard', as: :dashboard
  get 'newsfeed' => 'pages#newsfeed', as: :newsfeed
  get 'summary' => 'pages#summary', as: :summary
  get 'load_pictures' => 'pages#load_pictures', as: :picture
  get 'search' => 'pages#search', as: :search
  get 'price' => 'pages#price', as: :price
  get 'contact_us' => 'pages#contact_us', as: :contact_us
  post 'email_us' => 'pages#email_us', as: :email_us

  resources :subscriptions

  resources :tag_entries

  resources :opinions

  resources :beta_sign_ups, only: [:index, :create] do
    member do
      get :approve
      get :deny
      get :register
    end
  end

  resources :comments do
    collection do
      get :filter_sort
    end
  end

  resources :pictures
  resources :posts do
    member do
      post :judge
    end
  end

  resources :project_memberships do
    member do
      get :toggle
    end
  end

  # resources :organization_memberships do
  #   member do
  #     get :toggle
  #   end
  # end

  resources :projects do
    collection do
      post :join_by_code
    end
    member do
      post :show
      get :management
      get :generate_code
    end
  end

  resources :organizations do
    member do
      get :toggle
      get :manage_users
      post :manage_users
      post :update_departments
    end
  end

  resources :user_sessions

  resources :users do
    member do
      get :my_organization
    end

    collection do
      get :autocomplete_user_email
    end
  end

  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
