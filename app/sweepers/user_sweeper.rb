class UserSweeper < ActionController::Caching::Sweeper
  observe User
  
=begin
  # If our sweeper detects that a User was created call this
  def after_create(user)
          expire_cache_for(user)
  end
 
  # If our sweeper detects that a User was updated call this
  def after_update(user)
          expire_cache_for(user)
  end
 
  # If our sweeper detects that a User was deleted call this
  def after_destroy(user)
          expire_cache_for(user)
  end
 
  private
  def expire_cache_for(user)
    # Expire the index page now that we added a new user
    #expire_page(:controller => 'users', :action => 'index')
 
    # Expire a fragment
    expire_fragment('all_available_products')
  end
=end
end
