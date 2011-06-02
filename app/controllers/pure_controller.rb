class PureController < ApplicationController
  def users
    except = [:updated_at]
    @users = User.limit(100).offset(params[:skip])
    render :json => @users.to_json(:except=>except)
  end

  def photos
    @photos = Photo.limit(100).offset(params[:skip]).includes(:user)
    render :json => @photos.to_json(:only=>:created_at, :methods=>[:url, :user_username])
  end

  def posts
    except = [:updated_at, :subject_id, :usernames, :file_types]
    @posts = Post.limit(100).offset(params[:skip])
    render :json => @posts.to_json(:methods => [:user_username], :except=>except)
  end

  def relationships
    except = [:ignored_subjects, :user1_id, :user2_id, :created_at, :updated_at, :is_friend]
    @relationships = Relationship.limit(100).offset(params[:skip])
    render :json => @relationships.to_json(:methods => [:user1_username, :user2_username], :except=>except)
  end

end
