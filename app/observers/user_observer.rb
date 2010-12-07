class UserObserver < ActiveRecord::Observer
  def before_save(user)
    user.username = user.username.gsub ' ','_'
    user.email = user.email.downcase
  end
  
  def after_create(user)
    user.first_ip = user.last_sign_in_ip
    user.update_geo#this will save =/
    
    hosts = Hostness.where(:is_active=>true, :country=>user.first_geo_country)
    hosts.each do |host|
      user.follow host.user_id
      User.logger.info "FOLLOWING host at country #{user.first_geo_country}, user_id=>#{host.user_id}"
    end

    hosts = Hostness.where(:is_active=>true, :state=>user.first_geo_state)
    hosts.each do |host|
      user.follow host.user_id
      User.logger.info "FOLLOWING host at state #{user.first_geo_state}, user_id=>#{host.user_id}"
    end
=begin
    u2 = User.my_find 'executter'
    user.follow u2 if u2
    User.logger.info "FOLLOWING executter"
    
    u2 = User.my_find 'edgala'
    user.follow u2 if u2
    User.logger.info "FOLLOWING edgala"
=end
    if user.temp && user.temp[:follow_on_registration]
      u2 = User.find(user.temp[:follow_on_registration])
      user.follow u2
      User.logger.info "FOLLOWING inviter #{u2.username}"
      user.temp = nil
      user.save
    end
    
  end
end
