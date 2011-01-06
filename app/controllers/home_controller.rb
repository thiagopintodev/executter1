class HomeController < ApplicationController
  before_filter :my_must_be_logged

  def index
    @user = current_user#this makes user background show ;)
  end

  def new_post
    #return flash[:too_soon] = t "home.too_quick" unless not_many_posts
    post_attributes = params[:post]
    remote_ip = request.remote_ip
    
    post = current_user.posts.build(post_attributes)
    post.remote_ip = remote_ip
    if params[:file]
      @x = Xlink.create(:file=>params[:file], :user_id=>current_user.id)
      post.links = [ {:url=>@x.to_url, :name => @x.file_file_name} ]
      post.has_image = @x.file? && @x.file_image?
      post.has_file = @x.file? && !@x.file_image?
    end
    
    User.update(current_user.id, :post_id => post.id) if post.save
    render :nothing=>true
  end
  
  def after_sign_up
    u = current_user
    #u.first_ip = u.last_sign_in_ip
    u.update_geo
    hosts = Hostness.where(:is_active=>true)
    hosts = hosts.where("hostness_type=? OR country=?", Hostness::TYPE_UNIVERSAL, u.first_geo_country)
    hosts.each do |host|
      u.follow host.user_id
      u.logger.info "FOLLOWING host id-#{host.user_id}"
    end
    
    if hosts.size == 0
      hosts = Hostness.where(:is_active=>true, :hostness_type=>Hostness::TYPE_ESCAPE)
      hosts.each do |host|
        u.follow host.user_id
        u.logger.info "FOLLOWING escape host id-#{host.user_id}"
      end
    end
    
    if cookies[:follow_on_registration]
      u2 = User.find(cookies[:follow_on_registration])
      u.follow u2
      u.logger.info "FOLLOWING inviter @#{u2.username}"
    end
    redirect_to root_path
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
    options[:includes] = !params[:count]
    
    if params[:tab_id] == '1'
      @posts = current_user.my_followings_posts(options)
    elsif params[:tab_id] == '2'
      @posts = current_user.my_friends_posts(options)
    elsif params[:tab_id] == '3'
      options[:mentioned] = true
      @posts = current_user.my_followings_posts(options)
    end
    if params[:count]
      render :text=>@posts.count
    else
      render :layout=> false
    end
  end

  def settings_remove_bg
    current_user.update_attributes(:background_image => nil)
    redirect_to h_4_path
  end

  def settings_username
    index
    @page = Page.find_by_key('config_username')
  end
  def settings_password
    index
    @page = Page.find_by_key('config_password')
  end
  def settings_subjects
    index
    remaining = 12 - current_user.subjects.size
    remaining.times { current_user.subjects.build }
    @page = Page.find_by_key('config_subjects')
  end
  def settings_profile
    index
    @page = Page.find_by_key('config_profile')
  end
  def settings_design
    index
    @page = Page.find_by_key('config_design')
  end
  def settings_picture
    index
    @page = Page.find_by_key('config_picture')
  end

  #weird having 2 update methods, weireder having devise's default user update method =/
  def update
    return redirect_to :h_1 unless params[:user]

    if params[:user][:username]
      allow = User.username_allowed(params[:user][:username], :current_user => current_user)
      params[:user][:username] = allow[:allowed] ? allow[:regular] : ""
    end
    
    condition = params[:user][:username] || params[:user][:email] || params[:user][:password]
    
    updated = current_user.update_attributes params[:user] if !condition
    updated = current_user.update_with_password params[:user] if condition
    
    unless updated
      @errors = current_user.errors
      #cookies[:flavour] = current_user.flavour#why?
    end
    if updated
      set_current_locale    current_user.locale
      set_current_time_zone current_user.time_zone
    end
    redirect_to request.referrer
  end

  def new_photo
    p = current_user.photos.build
    p.img = params[:photo]
    if p.save
      current_user.update_attribute :photo_id, p.id
    else
      @errors = p.errors
    end
    redirect_to request.referrer
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
