class HomeController < ApplicationController
  before_filter :my_must_be_logged

  def index
    @user = current_user
    @post = Post.new
    #@post.post_attachments.build #replaced for pure html for performance 
    #quantidades
    @my_followers   = @user.they_relate_to_me.scope_follow
    @my_followings  = @user.i_relate_to_them.scope_follow
    @my_friends     = @user.they_relate_to_me.scope_friend
  end

  def ajax_index_tab1
    respond_to do |format|
      format.html { render :layout=> false }
      format.js  {
        #quem eu sigo
        my_followings  = current_user.i_relate_to_them.scope_follow

        #os relacionamentos
        @my_followings_hash = {}
        my_followings.each { |f| @my_followings_hash[f.user2_id] = nil }
        
        #os usuarios deles
        users = User.find(@my_followings_hash.keys)

        #preenchidos
        users.each { |u| @my_followings_hash[u.id] = u }
        
        #eu tbm me ouço...
        @my_followings_hash[current_user.id] = current_user

        #agora eu que já sei quem são as pessoas
        #agora vamos aos posts delas
        @posts = Post.where("user_id IN (?)", @my_followings_hash.keys)
        @posts = @posts.where("id < ?", params[:last_post_id]) if params[:last_post_id]
        @posts = @posts.order("id DESC").limit(Post::MY_LIMIT)
        #@posts = @posts.includes(:user)

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

  def ajax_username_available
    #return render :nothing => true unless params[:username] == "js"
    u = params[:username].downcase
    is_available = (u.length > 4 && !User.exists?(:username=>u)) || current_user.username==u
    render :inline=>is_available.to_s
  end
  
end
