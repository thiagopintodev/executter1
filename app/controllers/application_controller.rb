class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :my_locale
  helper_method :all_users

  protected
  
  def my_locale
    #cookies[:locale] = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless cookies[:locale]
    I18n.locale = cookies[:locale]
  end

  def all_users
    User.order(:id)
  end
  def my_must_be_logged
    redirect_to root_path, :notice=>"ONLY LOGGED IN" unless current_user
  end
  def my_admin_only
  #, :notice=>"ONLY ADMIN IN"
    redirect_to(root_path) unless current_user.admin?
  end
  
end
