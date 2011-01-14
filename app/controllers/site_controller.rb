class SiteController < ApplicationController

  caches_action :search, :cache_path => proc { |controller| "search|locale=#{I18n.locale}" }

  
  def index
    #return redirect_to home_index_path if current_user
    #0/0
    @user = User.first
    @followers_user = User.find (1..20).to_a
    render "event_mailer/followed", :layout=>false
    #render :text=>"user: #{User.count} | photo: #{Photo.count}  | box: #{Xlink.count} | posts: #{Post.count} | relationship: #{Relationship.count}"
  end

  def search
    @full_search = true
  end

  def ajax_search_data
    options = {}
    #options[:after] = params[:after]
    options[:before] = params[:before]
    #options[:includes] = !params[:count]
    hash = Post.new_search(params[:text], options)
    @posts = hash[:posts]
    @posts = @posts.includes(:user)
  end
  
  
  def check_email
    p = params[:user][:email]
    e = User.exists?(:email=>p)
    respond_to do |format|
      format.json { render :json => !e }
    end
  end
  
  def check_username
    p = params[:user][:username]
    regex_result = p[User::USERNAME_REGEX]
    return render :json => false unless p == regex_result
    
    usernamedown = regex_result.downcase
    return render :json => true if current_user && current_user.username.downcase == usernamedown

    ne = User.where("lower(username)=?", usernamedown).select(:id).limit(1).length==0
    render :json => ne
  end
  #to-deprecate
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
