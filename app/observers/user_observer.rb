class UserObserver < ActiveRecord::Observer
  def before_save(user)
    user.username = user.username.gsub ' ','_'
    user.email = user.email.downcase
  end
  
  def after_create(user)
    
  end
end
