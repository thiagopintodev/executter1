class PostsController < ApplicationController

  after_filter :my_suggest_registration, :only=> [:show,:previous, :next]
  before_filter :my_must_be_logged, :except => [:show,:previous, :next]
  
  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find params[:id] unless @post rescue return redirect_to :root
    @user = @post.user #so it customizes background ;)
    respond_to do |format|
      format.html { render :show }
      format.xml  { render :xml => @post }
    end
  end


  def previous
    @post = Post.limit(1).order('id DESC')
    @post = @post.where("id < ?", params[:id]).first
    @post = Post.last unless @post
    show
  end

  def next
    @post = Post.limit(1).order('id')
    @post = @post.where("id > ?", params[:id]).first
    @post = Post.first unless @post
    show
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy if @post && (@post.user_id == current_user.id || current_user.admin?)
    #@post.update_attribute(:is_deleted, true) if @post

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
      format.js  { render :nothing => true }
    end
  end
  
end
