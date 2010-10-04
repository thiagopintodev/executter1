class Post < ActiveRecord::Base
  attr_accessible :type, :user_id, :parent_post_id, :body, :ip_address, :is_public, :is_deleted, :img
  belongs_to :user

  default_scope where(:is_deleted => false)

  scope :scope_photos, where("img_file_name IS NOT NULL")

  validates_length_of :body, :maximum => 196
  #alias :ip_address, :remote_ip#old new

  MY_LIMIT = 3
  
  has_attached_file :img,
    MyConfig.paperclip_options({ :sm=>"50x50#", :me=>"100x100#" , :bi=>"200x200#" })

  def self.my_log_follow(u1, u2, options={})
    r = Relationship.my_find(u1, u2)
    r1 = r[:r1]
    a = r1.user1.username
    b = r1.user2.username
    
    p = r1.user1.posts.build
    p.remote_ip = options[:remote_ip]
    p.body = r1.is_follow ? "@#{a} is now following @#{b}" : "@#{a} is not following @#{b} anymore"
    p.body += ", now they're friends" if r1.is_friend
    logger.info " -------> "+ p.body
    p.save unless options[:no_log]
    
    p = r1.user2.posts.build
    p.body = r1.is_follow ? "@#{b} is now following me (@#{a})" : "@#{b} is not following me (@#{a}) anymore"
    p.body += ", now they're friends" if r1.is_friend
    #logger.info " -------> "+  p.body
    p.save unless options[:no_log]
    true
  end
    
  def self.my_list_by_user(user_id, last_post_id)
    r = where(:user_id=>user_id)
    r = r.where("id < ?", last_post_id) if last_post_id
    r.order("id DESC").limit(MY_LIMIT).includes(:user)
  end
end
