class Post < ActiveRecord::Base

  belongs_to :user, :counter_cache=>true
  belongs_to :subject, :counter_cache=>true
  has_many :post_attachments, :dependent => :destroy
  
  attr_accessible :type, :user_id, :subject_id, :body, :ip_address, :is_public, :is_deleted,
    :post_attachments, :post_attachments_attributes
  
  accepts_nested_attributes_for :post_attachments, :allow_destroy => true, :reject_if => :all_blank

  def read_first_post_attachments
    post_attachments.first || post_attachments.build
  end

  default_scope where(:is_deleted => false)

  scope :with_image, where(:has_image => true)
  scope :with_file, where(:has_file => true)

  validates :body, :presence => true, :length => { :within => 3..500 }

  MY_LIMIT = 10

  def self.count_latest_by_user(user_id, time)
    where(:user_id=>user_id).where("created_at > ?", Time.now - time).count
  end
  def self.count_latest_by_remote_ip(remote_ip, time)
    where(:remote_ip=>remote_ip).where("created_at > ?", Time.now - time).count
  end


  
  def self.get(u, source, options)
    user = MyFunctions.users([u]).first
    #must-have filters
    posts = Post.order("id DESC")
      .limit(options[:limit] || Post::MY_LIMIT)
      .includes([{:user => :photo}, :post_attachments, :subject])
    #
    posts = posts.where("id > ?", options[:after]) if options[:after]
    posts = posts.where("id < ?", options[:before]) if options[:before]
    posts = posts.with_image if options[:with_image]
    posts = posts.with_file if options[:with_file]
    posts = posts.where("body LIKE ?", "%@#{user.username}%") if options[:mentioned]
    #
    unless source#5 queries
      posts = posts.where(:user_id=>user.id)
    else#7 queries
      ignored_subjects_ids, users_ids = [], [user.id]
      source.each do |relation|
        ignored_subjects_ids |= relation.ignored_subjects
        users_ids << relation.user2_id
      end
      
      posts = posts.where("user_id IN (?)", users_ids)
      posts = posts.where("subject_id IS NULL OR subject_id NOT IN (?)", ignored_subjects_ids) if ignored_subjects_ids.length > 0
    end
    posts
  end


=begin
  
  def self.my_followings(user, options={})
    user = User.find(user) unless user.is_a? User
    @my_followings = where("user_id IN (?)", user.followings_as_hash(:and_me=>true).keys)
    @my_followings = @my_followings.where("id < ?", options[:last_post_id]) if options[:last_post_id]
    @my_followings = @my_followings.order("id DESC").limit(options[:limit] || Post::MY_LIMIT)
    @my_followings = @my_followings.includes(:post_attachments)
  end
  
  def self.recent_by_user(user_id, last_post_id)
    posts = where(:user_id=>user_id)
    posts = posts.where("id < ?", last_post_id) if last_post_id
    posts.order("id DESC").limit(MY_LIMIT).includes(:user, :post_attachments)
  end
  
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
=end
  
end
