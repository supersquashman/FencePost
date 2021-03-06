Rails.application.routes.draw do
  #devise_for :users
  devise_for :users, :skip => [:sessions]
  as :user do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  resources :users
  get '/equipment' => 'equipment#index'
  get '/roster' => 'users#index'
  get '/users' => 'users#index'
  get '/users/:id/positions' => 'users#positions'
  patch '/users/assign_position/:id' => 'users#assign_position'
  get '/users/:id/waiver' => 'users#waiver'
  get '/users/:id/dues' => 'users#dues'
  post '/users/:id/edit' => 'users#edit'
  patch '/users/update/:id' => 'users#update'
  post '/users/delete/:id' => 'users#destroy'
  get '/notifications' => 'notifications#index'
  resources :equipment
  post '/equipment/new' => 'equipment#new'
  post '/equipment/:id/edit' => 'equipment#edit'
  post '/equipment/delete/:id' => 'equipment#destroy'
  patch '/equipment/update/:id' => 'equipment#update'
  post '/equipment/eqrequest/:id' => 'equipment#eqrequest'
  post '/equipment/eqreturn/:id' => 'equipment#eqreturn'
  post '/equipment/eqrepair/:id' => 'equipment#eqrepair'
  post '/equipment/canceleqrequest/:id' => 'equipment#canceleqrequest'
  post '/notifications/approve/:id' => 'notifications#approve'
  post '/notifications/deny/:id' => 'notifications#deny'

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
