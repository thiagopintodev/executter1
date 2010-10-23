Ex1::Application.routes.draw do
  
  #resource :photo, :only => [:create]

  resources :banners, :path => "admin/banners" #except => :show
  #resources :flavours, :path => "admin/flavours"
  
  #resources :user_profiles
  #resources :posts
  
  devise_for :users #,  :path_names => { :sign_up => "/new", :sign_in => "/in", :sign_out => "/out" }

  get "l/:locale" => "site#set_locale", :as => :locale
  
  get "home/index"


  devise_scope :user do
    get "/out" => "devise/sessions#destroy",  :as => :out
    get "/new" => "devise/registrations#new", :as => :new
    get "/in"  => "devise/sessions#new",      :as => :in
    #get "/conf/2" => "devise/registrations#edit"
  end
  
  match "home/ajax_tab1(/:last_post_id)" => "home#ajax_index_tab1", :as => :ajax_home_index_tab1
  match "home/ajax_tab2(/:last_post_id)" => "home#ajax_index_tab2", :as => :ajax_home_index_tab2

  resources :users, :only =>[:show, :index, :update]
  resources :posts, :only =>[:index, :show, :create, :destroy]
  
  
  get "conf/ajax_username_available/:username" => "home#ajax_username_available"
  
  get "conf/1" => "home#settings_profile"
  get "conf/2" => "home#settings_account"
  get "conf/3" => "home#settings_design"
  get "conf/4" => "home#settings_picture"
  get "conf/5" => "home#settings_notice"
  get "conf/remove_bg" => "home#settings_remove_bg"
  match "conf/new_photo" => "home#new_photo", :method => :post
  match "conf/new_photo" => "home#settings_picture", :method => :get
  match "conf/update" => "home#update", :method => :post, :as => :home_update

  #root :to => "devise/passwords#edit"

  get "s/:text" => "site#search", :as => :search
  
  get "site/search"
  get "site/index"
  root :to => "home#index"


  match ":id" => "users#show", :as => "profile", :constraints => { :id => /\w{2,}/ }
  match "profile" => "users#show", :as => "my_profile"
  
  match ":mention_username/mention" => "home#index", :as => "mention"

  match ":id/ajax_tab1(/:last_post_id)" => "users#ajax_show_tab1", :as => :ajax_user_show_tab1
  match ":id/ajax_tab2(/:last_post_id)" => "users#ajax_show_tab2", :as => :ajax_user_show_tab2
  match ":id/ajax_tab3(/:last_post_id)" => "users#ajax_show_tab3", :as => :ajax_user_show_tab3
  
  match ":id/ajax_relation(/:property/:value)" => "users#ajax_show_relation", :as => :ajax_user_show_relation
  


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
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
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
