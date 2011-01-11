class Post < ActiveRecord::Base

  belongs_to :user, :counter_cache=>true
  belongs_to :subject, :counter_cache=>true
  
  attr_accessible :type, :user_id, :subject_id, :body, :ip_address, :is_public, :is_deleted
  
  scope :with_image, where(:has_image => true)
  scope :with_audio, where(:has_audio => true)
  scope :with_office, where(:has_office => true)
  scope :with_other, where(:has_other => true)

  serialize :links
  serialize :file_types

  validates :body, :presence => true, :length => { :within => 1..200 }

  MY_LIMIT = 10
  def self.post_size_limit
    MyConfig.production? ? 10 : 3
  end

  def self.count_latest_by_user(user_id, time)
    where(:user_id=>user_id).where("created_at > ?", Time.now - time).count
  end
  def self.count_latest_by_remote_ip(remote_ip, time)
    where(:remote_ip=>remote_ip).where("created_at > ?", Time.now - time).count
  end

  def self.search(text, options={})
    return [] unless text && text.length > 2
    text = text.downcase
    posts = order("id DESC").limit(post_size_limit)
    user_ids = User.where("lower(username)=:text OR lower(full_name) LIKE :text", :text=>"%#{text}%").select(:id).collect(&:id)
    posts = posts.where('lower(body) LIKE :text OR lower(links) LIKE :text OR user_id IN (:user_ids)', :text=>"%#{text}%", :user_ids => user_ids)
    posts = posts.where("id > ?", options[:after]) if options[:after]
    posts = posts.where("id < ?", options[:before]) if options[:before]
    posts
  end
  
  def self.get(u, source, options={})
    user = MyFunctions.users([u]).first
    #must-have filters
    posts = order("id DESC").limit(post_size_limit)
    #
    #posts = posts.includes([{:user => :photo}, :subject]) if options[:includes]
    posts = posts.includes([{:user => :photo}]) if options[:includes]
    
    posts = posts.where("id > ?", options[:after]) if options[:after]
    posts = posts.where("id < ?", options[:before]) if options[:before]
    posts = posts.with_image if options[:with_image]
    posts = posts.with_audio if options[:with_audio]
    posts = posts.with_office if options[:with_office]
    posts = posts.with_other if options[:with_other]
    posts = posts.where("lower(body) LIKE ?", "%@#{user.username.downcase}%") if options[:mentioned]
    #
    unless source#5 queries
      posts = posts.where(:user_id=>user.id)
    else#7 queries
      ignored_subjects_ids, users_ids = [], [user.id]
      source.each do |relation|
        #ignored_subjects_ids |= relation.ignored_subjects
        users_ids << relation.user2_id
      end
      
      posts = posts.where("user_id IN (?)", users_ids)
      #posts = posts.where("subject_id IS NULL OR subject_id NOT IN (?)", ignored_subjects_ids) if ignored_subjects_ids.length > 0
    end
    posts
  end


=begin
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
