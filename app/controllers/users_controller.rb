class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    @user = User.find(current_user.id)
    
    @user.update_attributes!(params[:user]) #if current_user.id.to_s == params[:id]
    redirect_to request.referer
  end
  
  def show
    if params[:id] != "profile"
      @user = User.my_find(params[:id])
    elsif current_user
      @user = current_user
    end
    return redirect_to root_path unless @user
    @isme = current_user && @user.id == current_user.id
  end

  
  def ajax_show_relation
    #js only
    @user = User.find(params[:id])
    return unless current_user
    return if current_user.id.to_s == params[:id].to_s

    
    @r = Relationship.my_find(current_user, @user)

    #if this request has params, it means we're changing the values of the relationships
    p1, p2 = params[:p1], params[:p2]
    if p1
      @r = Relationship.change(p1, current_user, @user, p2)
      @user = User.find(params[:id])
    end

    #options = {:p1=>'follow', :p2=>true}
    #ajax_user_show_relation_path(options)
    
    #this is to help compose the view and it's only temporary code
    button_unfollow = {:text=>"- Follow", :params=>{:p1=>'follow', :p2=>false}}
    button_friends = {:text=>"+ Friend",  :params=>{:p1=>'follow', :p2=>true}}
    button_follow = {:text=>"+ Follow",   :params=>{:p1=>'follow', :p2=>true}}
    
    unless @r.is_blocked
      
      @main_button = unless @r.is_follower
        @r.is_followed ? button_friends : button_follow
      else
        button_unfollow
      end
      
    end
    
  end
=begin
    #options = {:remote_ip=>request.remote_ip, :no_log=>true}
    #Relationship.set_block(@r, p_v) if params[:property] == "block"
    #@r = Relationship.change(current_user, @user, 'follow', p_v, options) if params[:property] == "follow"
    
    #r1, r2 = @r[:r1], @r[:r2]
=end

  
  def ajax_show_tab1
    ajax_show_tab_handler()
  end
  def ajax_show_tab2
    ajax_show_tab_handler(:with_image=>true)
  end
  def ajax_show_tab3
    ajax_show_tab_handler(:with_file=>true)
  end

  protected
  
  def ajax_show_tab_handler(options = {})
    respond_to do |format|
      format.html { render :layout=> false }
      #format.js  { @posts = Post.recent_by_user(params[:id], params[:last_post_id]) }
      format.js {
        #@posts = Post.recent_by_user(params[:id], params[:last_post_id])
        @user = User.find(params[:id])
        options[:limit] = params[:limit]
        options[:after] = params[:after]
        options[:before] = params[:before]
        @posts = @user.my_posts(options)
        render :ajax_show_tab
      }
    end
  end
end
