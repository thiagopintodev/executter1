Ex1::Application.routes.draw do
  
  root :to => "site#index"
  get "/u/out" => "site#index"
  get "/u/new" => "site#index"
  get "/u/in"  => "site#index"

  get "pure/users"
  get "pure/photos"
  get "pure/posts"
  get "pure/relationships"
  

  constraints :subdomain => /box/ do
    match ":micro(.:format)" => "xlinks#display", :as => :micro
  end
  match "x/:micro(.:format)" => "xlinks#display", :as => :xmicro
  match "z/:key(.:format)" => "pages#show", :as => :z

  #resource :photo, :only => [:create]

  #resources :flavours, :path => "admin/flavours"
  
  #resources :user_profiles
  #resources :posts
  
  devise_for :users #,  :path_names => { :sign_up => "/new", :sign_in => "/in", :sign_out => "/out" }

  get "l/:locale" => "site#do_locale", :as => :locale
  
  devise_scope :user do
    get "/u/out" => "devise/sessions#destroy",  :as => :out
    get "/u/new" => "devise/registrations#new", :as => :new
    get "/u/in"  => "devise/sessions#new",      :as => :in
  end
  match "/out" => redirect("/u/out")
  match "/new" => redirect("/u/new")
  match "/in" => redirect("/u/in")
  
  resources :users, :path => "u", :only =>[:show, :index, :update] do
    member do
      get "ajax/followings_thumbs" => "users#ajax_followings_thumbs"
      match "ajax/tab/:tab_id" => "users#ajax_show_tab", :as => "ajax_tab"
      match "ajax/tab_data/:tab_id" => "users#ajax_show_tab_data", :as => "ajax_tab_data"
      
      match "ajax/tab_data/:tab_id/before/:before" => "users#ajax_show_tab_data_before"
      match "ajax/tab_data/:tab_id/after/:after" => "users#ajax_show_tab_data_after"
      match "ajax/tab_data/:tab_id/after/:after/count/:count" => "users#ajax_show_tab_data_after_count"
      
      match "ajax/relation" => "users#ajax_show_relation", :as => :relation
      match "ajax/host/:val" => "users#set_host", :as => :set_host
    end
  end
  resources :posts, :path => "p", :only =>[:show, :destroy] do
    member do
      get 'next', 'previous'
    end
  end

  match "h/ajax_tab/:tab_id" => "home#ajax_index_tab", :as => :ajax_home_index_tab
  match "h/ajax_tab_data/:tab_id" => "home#ajax_index_tab_data", :as => :ajax_home_index_tab_data
  match "h/ajax_tab_data/:tab_id/before/:before" => "home#ajax_index_tab_data"
  match "h/ajax_tab_data/:tab_id/after/:after" => "home#ajax_index_tab_data"
  match "h/ajax_tab_data/:tab_id/after/:after/count/:count" => "home#ajax_index_tab_data"
  
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
  
  get "s/ajax_username_available/:username" => "site#ajax_username_available"
  
  get "s" => "site#search", :as => :search
  post "s/data" => "site#ajax_search_data", :as => :search_data
  
  get 's/check_email' => "site#check_email"
  get 's/check_username' => "site#check_username"
  
  get "site/index"
  #post "/", :controller => :home, :action => :create_post, :as => :my_create_post

  match "p" => "users#redirect", :as => "my_profile"
  match ":username" => "users#show", :as => "profile", :constraints => { :username => User::USERNAME_REGEX }
  match ":username/list/:list" => redirect("/%{username}/%{list}")
  match ":username/:list" => "users#list", :as => :user_list, :constraints => {:list => /followers|followings|blockers|blockings|friends/}
  
  match ":mention_username/mention" => "home#index", :as => "mention"

  resources :pages, :path => "a/pages"
  resources :xlinks, :path => "a/xlinks"
  resources :hostnesses, :path => "a/hostnesses", :except => :show
  resources :banners, :path => "a/banners" #except => :show
  
  get "a" => "admin#index"
  get "a/emails" => "admin#emails"
  get "a/numbers" => "admin#numbers"

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
