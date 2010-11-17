class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :my_locale
  helper_method :all_users

  protected
  
  def my_locale
    #no  www
    redirect_to("http://executter.com") and return false if request.env["SERVER_NAME"].starts_with? "www"
    #cookies[:locale] = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless cookies[:locale]
    I18n.locale = cookies[:locale]
  end

  def all_users
    User.order(:created_at) #:id
  end
  def my_must_be_logged
  #, :notice=>"ONLY LOGGED IN"
    redirect_to in_path and return false unless current_user
  end
  def my_admin_only
  #, :notice=>"ONLY ADMIN IN"
    redirect_to root_path and return false unless current_user.admin?
  end
  
end
