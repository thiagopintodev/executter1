class UserObserver < ActiveRecord::Observer
=begin
  def after_create(user)
   #user.create_user_profile unless user.user_profile
  end
=end
  def before_save(user)
    #User.logger.info('observer before create :))))))))))))))')
    #puts 'observer before save <-------------'
    user.username = user.username.downcase
  end
end
