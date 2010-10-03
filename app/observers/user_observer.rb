class UserObserver < ActiveRecord::Observer
  def after_create(user)
    #User.logger.info('observer New user :))))))))))))))')
    #puts "observer after create :)"
    
    unless user.user_profile
      user.create_user_profile
    end
  end
  def before_create(user)
    #User.logger.info('observer before create :))))))))))))))')
    #puts 'observer before create <-------------'
    #user.username = user.username.downcase
  end
end
