class UsersController < ApplicationController

  after_filter :my_suggest_registration, :only=>:show
  before_filter :my_admin_only, :only => :set_host

  def set_host
    User.update(params[:id], :is_host => params[:val]=='1')
    redirect_to user_path(params[:id])
  end

  def list
    fill_user
    return render :nothing=>true unless @user
    params[:list] = 'followers' unless 'followers|followings|blockers|blockings|friends'.include? params[:list]
    assossiation = params[:list]
    array_of_user_id = @user.send(assossiation).select('user2_id').collect(&:user2_id)
    @posts = User.find(array_of_user_id).collect { |user| user.posts.build(:body=>'Loren Ipsum') }
  end

  def list_data
    render :text=>":D"
  end
  
  def index
    @users = User.all
  end

  def update
    @user = User.find(current_user.id)
    
    @user.update_attributes!(params[:user]) #if current_user.id.to_s == params[:id]
    redirect_to request.referer
  end

  def redirect
    redirect_to profile_path(current_user.username)
  end
  
  def show
    fill_user
    return redirect_to root_path unless @user
    @isme = @user.id == current_user_id
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
    @user = User.find(params[:id])
    options = (@user.posts_count > 0) ? {:layout=> false} : {:nothing => true}
    render options
  end
  
  def ajax_show_tab_data
    options = {}
    options[:limit] = params[:limit]
    options[:after] = params[:after]
    options[:before] = params[:before]
    options[:includes] = !params[:count]

    if params[:tab_id] == '2'
      options[:with_image] = true
    elsif params[:tab_id] == '3'
      options[:with_file] = true
    end
    
    @user = User.find(params[:id])
    @posts = @user.my_posts(options)
    
    if params[:count]
      render :text=>@posts.count
    else
      render :layout=> false
    end
  end

  private

  def fill_user
    if params[:id]
      @user = User.my_find(params[:id])
    elsif current_user?
      @user = current_user
    end
  end
  
end
