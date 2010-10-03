class UserObserver < ActiveRecord::Observer
=begin
  def after_create(user)
   #user.create_user_profile unless user.user_profile
  end
  def before_create(user)
    #User.logger.info('observer before create :))))))))))))))')
    #puts 'observer before create <-------------'
    #user.username = user.username.downcase
  end
=end
end
