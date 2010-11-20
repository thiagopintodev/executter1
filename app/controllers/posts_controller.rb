class PostsController < ApplicationController

  # GET /posts/1
  # GET /posts/1.xml
  def show
    begin
      @post = Post.find(params[:id])
    rescue
      redirect_to root_path
      return false
    end
    @user = @post.user #so it customizes background ;)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    #Post.delete_all(:user_id => current_user.id, :id=>params[:id])
    @post = Post.where(:user_id => current_user.id, :id=>params[:id]).first
    @post.destroy if @post
    #@post.update_attribute(:is_deleted, true) if @post

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
      format.js  { render :nothing => true }
    end
  end
  
end
