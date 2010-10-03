class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    @user = User.find(current_user.id)
    
    @user.update_attributes!(params[:user]) #if current_user.id.to_s == params[:id]
    redirect_to "/home/settings_1profile"
  end
  
  def show
    if params[:id] != "profile"
      @user = User.my_find(params[:id])
    elsif current_user
      @user = current_user
    else
      return redirect_to root_path
    end
    @isme = @user.id == current_user.id

    #quantidades
    @my_followers   = @user.they_relate_to_me.scope_follow
    @my_followings  = @user.i_relate_to_them.scope_follow
    @my_friends     = @user.they_relate_to_me.scope_friend
    
    #os relacionamentos
    @my_followers_hash = {}
    @my_followers.each { |f| @my_followers_hash[f.user1_id] = nil }
    
    #os usuarios deles
    users = User.find(@my_followers_hash.keys)
    
    #preenchidos
    users.each { |u| @my_followers_hash[u.id] = u }
  end

  def ajax_show_relation
    #js only
    @user = User.find(params[:id])
    return if current_user.id == @user.id
    #
    @r = Relationship.my_find(current_user.id, @user.id)

    p_v = params[:value]=="1"
    options = {:remote_ip=>request.remote_ip, :no_log=>true}
    
    #Relationship.set_block(@r, p_v) if params[:property] == "block"
    @r = Relationship.set_follow(current_user.id, @user.id, p_v, options) if params[:property] == "follow"
    
    make_unfollow = {:text=>"- Follow", "data-k"=>"follow", "data-v"=>"0"}
    make_friends = {:text=>"+ Friend", "data-k"=>"follow", "data-v"=>"1"}
    make_follow = {:text=>"+ Follow", "data-k"=>"follow", "data-v"=>"1"}
    
    r1, r2 = @r[:r1], @r[:r2]
    
    unless r2.is_block
      
      @button = unless r1.is_follow
        r2.is_follow ? make_friends : make_follow
      else
        make_unfollow
      end


    end
    
  end

  
  def ajax_show_tab1
    
    respond_to do |format|
      format.html { render :layout=> false }
      format.js  { @posts = Post.my_list_by_user(params[:id], params[:last_post_id]) }
    end
  end
  def ajax_show_tab2
    render :layout=> false
  end
  def ajax_show_tab3
    render :layout=> false
  end
end
