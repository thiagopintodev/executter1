Ex1::Application.routes.draw do
  

  resources :xlinks, :path => "a/xlinks"
  match "x/:micro(.:format)" => "xlinks#display", :as => :micro
  constraints :subdomain => /box/ do
    match ":micro(.:format)" => "xlinks#display", :as => :microbox
  end

  #resource :photo, :only => [:create]

  resources :hostnesses, :path => "a/hostnesses", :except => :show
  resources :banners, :path => "a/banners" #except => :show
  get "a"  => "banners#index"
  #resources :flavours, :path => "admin/flavours"
  
  #resources :user_profiles
  #resources :posts
  
  devise_for :users #,  :path_names => { :sign_up => "/new", :sign_in => "/in", :sign_out => "/out" }

  get "l/:locale" => "site#do_locale", :as => :locale
  
  #get "home/index"


  devise_scope :user do
    get "/out" => "devise/sessions#destroy",  :as => :out
    get "/new" => "devise/registrations#new", :as => :new
    get "/in"  => "devise/sessions#new",      :as => :in
    #get "/conf/2" => "devise/registrations#edit"
  end
  
  resources :users, :only =>[:show, :index, :update]
  resources :posts, :only =>[:show, :destroy] #:create, 

  
  #match "h/ajax_tab1" => "home#ajax_index_tab1", :as => :ajax_home_index_tab1
  #match "h/ajax_tab2" => "home#ajax_index_tab2", :as => :ajax_home_index_tab2
  #match "h/ajax_tab3" => "home#ajax_index_tab3", :as => :ajax_home_index_tab3
  match "h/ajax_tab/:tab_id" => "home#ajax_index_tab", :as => :ajax_home_index_tab
  match "h/ajax_tab_data/:tab_id" => "home#ajax_index_tab_data", :as => :ajax_home_index_tab_data
  
  get "h/after_sign_up" => "home#after_sign_up"
  get "h/1" => "home#settings_profile"
  get "h/2" => "home#settings_username"
  get "h/3" => "home#settings_password"
  get "h/4" => "home#settings_design"
  get "h/5" => "home#settings_picture"
  get "h/6" => "home#settings_subjects"
  get "h/remove_bg" => "home#settings_remove_bg", :as => :home_remove_bg
  match "h/new_photo" => "home#new_photo", :method => :post, :as => :home_new_photo
  match "h/new_photo" => "home#settings_picture", :method => :get, :as => :home_new_photo
  match "h/update" => "home#update", :method => :post, :as => :home_update
  match "h/new_post" => "home#new_post"
  
  get "s/:text" => "site#search", :as => :search
  get "s/ajax_username_available/:username" => "site#ajax_username_available"
  
  get "site/search"
  get "site/index"
  #post "/", :controller => :home, :action => :create_post, :as => :my_create_post
  root :to => "home#index"

  match "p" => "users#redirect", :as => "my_profile"
  match ":id" => "users#show", :as => "profile", :constraints => { :id => User::USERNAME_REGEX }
  
  
  match ":mention_username/mention" => "home#index", :as => "mention"


  match ":id/ajax_tab/:tab_id" => "users#ajax_show_tab", :as => :ajax_user_show_tab
  match ":id/ajax_tab_data/:tab_id" => "users#ajax_show_tab_data", :as => :ajax_user_show_tab_data

#  match ":id/ajax_tab1(/:last_post_id)" => "users#ajax_show_tab1", :as => :ajax_user_show_tab1
#  match ":id/ajax_tab2(/:last_post_id)" => "users#ajax_show_tab2", :as => :ajax_user_show_tab2
#  match ":id/ajax_tab3(/:last_post_id)" => "users#ajax_show_tab3", :as => :ajax_user_show_tab3
  
  match ":id/ajax_relation" => "users#ajax_show_relation", :as => :ajax_user_show_relation
  
  match ":id/set_host/:val" => "users#set_host", :as => :user_set_host


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
