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

  def numbers
  end

end
