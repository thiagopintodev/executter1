class HomeController < ApplicationController
  before_filter :my_must_be_logged

  def index
    @user = current_user
  end
  def new_post
    render :layout=>'iframe'
    unless params[:post]
      @post = Post.new
    else
      if not_many_posts
        current_user.my_create_post(params[:post], request.remote_ip)
        @post = Post.new
      else
        @post = Post.new(params[:post])
        flash[:too_soon] = t "home.too_quick"
      end
    end
  end



=begin
  def create_post
    if not_many_posts
      current_user.my_create_post(params[:post], request.remote_ip)
      @post = Post.new
    else
      @post = Post.new(params[:post])
      flash[:too_soon] = t "home.too_quick"
    end
    @user = current_user
    render :index
  end
=end



  def ajax_index_tab
    render :layout=> false #view decides small changes because they don't depend on database
  end
  
  def ajax_index_tab_data
    options = {}
    options[:limit] = params[:limit]
    options[:after] = params[:after]
    options[:before] = params[:before]
    if params[:tab_id] == '1'
      @posts = current_user.my_followings_posts(options)
    elsif params[:tab_id] == '2'
      @posts = current_user.my_friends_posts(options)
    elsif params[:tab_id] == '3'
      options[:mentioned] = true
      @posts = current_user.my_followings_posts(options)
    end
    render :layout=> false
  end
=begin
  def ajax_index_tab1
    respond_to do |format|
      format.html { render :layout=> false }
      format.js  {
        options = {}
        options[:limit] = params[:limit]
        options[:after] = params[:after]
        options[:before] = params[:before]
        @posts = current_user.my_followings_posts(options)
        render :ajax_index_tab
      }
    end
  end
  
  def ajax_index_tab2
    respond_to do |format|
      format.html { render :layout=> false }
      format.js  {
        options = {}
        options[:limit] = params[:limit]
        options[:after] = params[:after]
        options[:before] = params[:before]
        @posts = current_user.my_friends_posts(options)
        render :ajax_index_tab
      }
    end
  end
  
  def ajax_index_tab3
    respond_to do |format|
      format.html { render :layout=> false }
      format.js  {
        options = {}
        options[:limit] = params[:limit]
        options[:after] = params[:after]
        options[:before] = params[:before]
        options[:mentioned] = true
        @posts = current_user.my_followings_posts(options)
        render :ajax_index_tab
      }
    end
  end
=end





  def ajax_username_available
    u = params[:username].downcase
    is_available = (u.length > 4 && !User.exists?(:username=>u)) || current_user.username==u
    render :inline=>is_available.to_s
  end

  def settings_remove_bg
    @user = settings_design
    @user.background_image = nil
    @user.save
    render :settings_design
  end

  def settings_login
    @user = current_user
  end
  def settings_subjects
    @user = current_user
    remaining = 12 - @user.subjects.size
    remaining.times { @user.subjects.build }
  end
  def settings_profile
    @user = current_user
  end
  def settings_design
    @user = current_user
  end
  def settings_picture
    @user = current_user
  end

  #weird having 2 update methods, weireder having devise's default user update method =/
  def update
  #user.update_with_password
    unless current_user.update_attributes params[:user]
    #unless current_user.update_with_password params[:user]
      @errors = current_user.errors
      cookies[:flavour] = current_user.flavour
    end
    settings_subjects
    render params[:return_action]
  end

  def new_photo
    p = current_user.photos.build
    p.img = params[:photo]
    if p.save
      current_user.update_attribute :photo_id, p.id
    else
      @errors = p.errors
    end
    settings_picture
    render :settings_picture
  end





  
  
  protected
  
  def not_many_posts
    #return false
    #return false if Post.count_latest_by_user(current_user.id, 30.seconds) > 2
    return false if Post.count_latest_by_user(current_user.id, 3.minutes) > 6
    return false if Post.count_latest_by_remote_ip(request.remote_ip, 5.minutes) > 60
    return false if Post.count_latest_by_user(current_user.id, 1.hour) > 60
    true
  end
end
