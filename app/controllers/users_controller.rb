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
    #button_unfollow = {:text=>"- Follow", :params=>{:p1=>'follow', :p2=>false}}
    button_friends = {:text=>"+ Friend",  :params=>{:p1=>'follow', :p2=>true}}
    button_follow = {:text=>"+ Follow",   :params=>{:p1=>'follow', :p2=>true}}

    @main_button = @r.is_followed ? button_friends : button_follow unless @r.is_follower || @r.is_blocked

=begin
    unless @r.is_blocked
      
      @main_button = unless @r.is_follower
        @r.is_followed ? button_friends : button_follow
      else
        button_unfollow
      end
      
    end
=end
  end
  
  def ajax_show_tab
    render :layout=> false
  end
  
  def ajax_show_tab_data
    options = {}
    options[:limit] = params[:limit]
    options[:after] = params[:after]
    options[:before] = params[:before]

    if params[:tab_id] == '2'
      options[:with_image] = true
    elsif params[:tab_id] == '3'
      options[:with_file] = true
    end
    
    @user = User.find(params[:id])
    @posts = @user.my_posts(options)
    
    render :layout=> false
  end
  
end
