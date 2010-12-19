class SiteController < ApplicationController
  def index
    #return redirect_to home_index_path if current_user
  end

  def search
    @full_search = true
  end

  def ajax_search_data
    options = {}
    options[:after] = params[:after]
    options[:before] = params[:before]
    #options[:includes] = !params[:count]
    
    @posts = Post.search(params[:text], options)
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
