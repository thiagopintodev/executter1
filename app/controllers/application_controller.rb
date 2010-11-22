class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :my_before_every_request
  helper_method :all_users, :current_user?

  def current_user?
    !!session["warden.user.user.key"]
  end
  def current_user_id
    return nil unless current_user?
    session['warden.user.user.key'][1]
  end
  
  protected
  
  def my_before_every_request
    #no  www
    redirect_to("http://executter.com") and return false if request.env["SERVER_NAME"].starts_with? "www"
    #cookies[:locale] = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless cookies[:locale]
    I18n.locale = cookies[:locale] if cookies[:locale]
    #Time.zone = cookies[:tz]
  end

  def set_current_time_zone(tz)
    cookies[:tz] = tz
  end

  def set_current_locale(locale)
    cookies[:locale] = locale
  end
  
  def all_users
    User.order("id DESC")
  end
  def my_must_be_logged
  #, :notice=>"ONLY LOGGED IN"
    redirect_to in_path and return false unless current_user?
  end
  def my_admin_only
  #, :notice=>"ONLY ADMIN IN"
    redirect_to root_path and return false unless current_user && current_user.admin?
  end
  
end
