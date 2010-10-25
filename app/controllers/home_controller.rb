class HomeController < ApplicationController
  before_filter :my_must_be_logged

  def index
    @user = current_user
    @post = Post.new
    #@post.post_attachments.build #replaced for pure html for performance 
    #quantidades
    #@my_followers   = @user.they_relate_to_me.scope_follow
    #@my_followings  = @user.i_relate_to_them.scope_follow
    #@my_friends     = @user.they_relate_to_me.scope_friend
  end

  def ajax_index_tab1
    respond_to do |format|
      format.html { render :layout=> false }
      format.js  {
        #quem eu sigo
        #@my_followings_as_hash = current_user.my_followings_as_hash
        #@posts = Post.my_followings(current_user.id, last_post_id: params[:last_post_id], limit: params[:limit])
        #o que quem eu sigo diz
        #@followings_as_hash_and_me = current_user.followings_as_hash(:and_me=>true)
        #@posts = current_user.followings_posts(:last_post_id => params[:last_post_id], :limit => params[:limit])
        options = {}
        options[:limit] = params[:limit]
        options[:after] = params[:after]
        options[:before] = params[:before]
        @posts = current_user.my_followings_posts(options)

=begin
  melhor forma:
  trazer meus amigos,
  trazer posts dos meus amigos(via id)
  e colocar os nomes/fotos deles num @hash
  assinalar qual foto usar em qual post via iterações de código (são apenas 10 lol)
=end
      }
    end
  end

  def ajax_index_tab2
    render :layout=> false
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

  def ajax_username_available
    #return render :nothing => true unless params[:username] == "js"
    u = params[:username].downcase
    is_available = (u.length > 4 && !User.exists?(:username=>u)) || current_user.username==u
    render :inline=>is_available.to_s
  end
  
end
