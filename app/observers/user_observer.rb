class UserObserver < ActiveRecord::Observer
  def before_save(user)
    user.username = user.username.gsub ' ','_'
    user.email = user.email.downcase
  end
  
  def after_create(user)
    u2 = User.find_by_username('executter')
    user.follow u2 if u2
    User.logger.info "FOLLOWING executter"
    u2 = User.find_by_username('edgala')
    user.follow u2 if u2
    User.logger.info "FOLLOWING edgala"
  end
end
