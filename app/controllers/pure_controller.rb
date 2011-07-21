class PureController < ApplicationController
  def users
    except = [
      :updated_at, :admin, :authentication_token,:failed_attempts, :current_sign_in_ip, :current_sign_in_at,
      :background_attachment_policy,:background_color, :background_image_content_type, :background_image_file_name,
      :background_image_file_size,:background_image_updated_at,:background_position, :background_repeat_policy,
      :birth_policy, :confirmation_sent_at, :confirmation_token, :confirmed_at, :remember_created_at,
      :last_sign_in_at, :last_sign_in_ip, :locked_at, :reset_password_token, :remember_token,
      :photo_id, :post_id, :posts_count, :relations_hash_count, :unlock_token, :sign_in_count      
    ]

    
    
    @users = User.limit(1000).offset(params[:skip]).order("id")
    render :json => @users.to_json(:except=>except)
  end

  def photos
    @photos = Photo.limit(1000).offset(params[:skip]).order("id").includes(:user)
    photos2 = []
    @photos.each do |p|
      photos2 << p if p.img?
    end
    render :json => photos2.to_json(:only=>:created_at, :methods=>[:url, :filename, :user_username])
  end

  def posts
    except = [:updated_at, :subject_id, :usernames, :file_types, :links]
    @posts = Post.limit(1000).after(params[:last_post_id]).order("id").includes(:user)
    render :json => @posts.to_json(:methods => [:user_username, :filename, :url], :except=>except)
    #
  end

  def relationships
    except = [:ignored_subjects, :user1_id, :user2_id, :created_at, :updated_at, :is_friend]
    @relationships = Relationship.limit(1000).offset(params[:skip]).order("id").includes(:user1, :user2)
    render :json => @relationships.to_json(:methods => [:user1_username, :user2_username], :except=>except)
  end

end
