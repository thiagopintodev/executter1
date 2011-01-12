class AdminController < ApplicationController

  before_filter :my_admin_only
  layout "admin"
  
  def index
  end

  def emails
    c = DelayedMailFollowed.group(:user_id).count
    @followers_count = c.values.sum
    @emails_count = c.length
  end

  def do_emails
    user_ids = DelayedMailFollowed.select("distinct user_id").limit(10).collect &:user_id
    user_ids.each do |user_id|
      @user = User.find(user_id)
      dmf_list = DelayedMailFollowed.where(:user_id=>user_id).includes(:follower_user)
      dmf_list
      @followers_user = dmf_list.collect(&:follower_user)
      EventMailer.followed @user, @followers_user
      m.deliver
    end
    render :nothing => true
  end

  def numbers
  end

end
