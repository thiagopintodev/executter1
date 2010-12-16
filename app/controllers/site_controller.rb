class SiteController < ApplicationController
  def index
    #return redirect_to home_index_path if current_user
    MyFunctions.migrate_pa_to_x
    render :text=> "migrated!"
  end

  def ajax_username_available
    allow = User.username_allowed(params[:username], :current_user => current_user)
    render :inline => allow[:allowed] ? allow[:regular] : '0'
  end

  def do_locale
    if params[:locale]
      set_current_locale params[:locale]
      current_user.update_attributes(:locale=>cookies[:locale]) if current_user?
    end
    redirect_to request.referer
  end
end
