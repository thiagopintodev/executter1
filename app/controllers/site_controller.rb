class SiteController < ApplicationController
  def index
    #return redirect_to home_index_path if current_user
  end

  def ajax_username_available
    allow = User.username_allowed(params[:username], :current_user => current_user)
    render :inline => allow[:allowed] ? allow[:regular] : '0'
  end

  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    redirect_to request.referer
  end
end
