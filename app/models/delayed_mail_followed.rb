class DelayedMailFollowed < ActiveRecord::Base
  belongs_to :follower_user, :class_name => "User"

  class << self
    def send_them
      user_ids = DelayedMailFollowed.select("distinct user_id").limit(200).collect &:user_id
      puts s = "fetching #{user_ids.length} distinct emails to send --> #{Time.now}"
      user_ids.each do |user_id|
        user = User.find(user_id)
        dmf_list = DelayedMailFollowed.where(:user_id=>user_id).includes(:follower_user)
        followers_user = dmf_list.collect(&:follower_user)
        ids = dmf_list.collect(&:id)
        puts a = "\nsending #{ids.length} notifications to @#{user.email}  --> #{Time.now}"
        s += a
        m = EventMailer.followed user, followers_user
        m.deliver
        DelayedMailFollowed.delete(ids)
      end
      puts a = "\ndone! sending #{user_ids.length} distinct emails  --> #{Time.now}"
      s += a
    end
  end
  
end
