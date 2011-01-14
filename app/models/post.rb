class Post < ActiveRecord::Base

  belongs_to :user, :counter_cache=>true
  belongs_to :subject, :counter_cache=>true
  
  attr_accessible :type, :user_id, :subject_id, :body, :ip_address, :is_public, :is_deleted
  
  scope :with_image, where("file_types LIKE ?", "%#{:jpg}%")
  scope :with_any, where("file_types IS NOT NULL")
  #scope :with_audio, where(:has_audio => true)
  #scope :with_office, where(:has_office => true)
  #scope :with_other, where(:has_other => true)
  
  #SCOPE METHODS
  def self.mentioned(username)
    #where("usernames LIKE ?", "%@#{username.downcase}%")
    where("usernames LIKE ?", "% #{username.downcase} %")
  end
  def self.after(id)
    id ? where("id > ?", id) : scoped
  end
  def self.before(id)
    id ? where("id < ?", id) : scoped
  end
  
  serialize :links
  serialize :file_types

  validates :body, :presence => true, :length => { :within => 1..200 }

  MY_LIMIT = 10
  def self.post_size_limit
    MyConfig.production? ? 10 : 3
  end

  #EVENT METHODS
  before_save :my_before_save
  def my_before_save
    #self.sea = "#{body.downcase} #{links.first.values.join(' ').downcase if links}"
    a = User.usernames_in_text(self.body)
    u = a.join(' ').downcase if a.size > 0
    self.usernames = " #{u} " if a.size > 0
    self.file_types = [ MyF.file_type(self.links.first[:name]) ] if self.links and self.links.first#this line should be deleted, only added to fix all posts in a migration
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
    hash = {}
    #must-have filters
    posts = order("id DESC").limit(post_size_limit)
    #
    #posts = posts.includes([{:user => :photo}]) if options[:includes]
    
    posts = posts.where("id > ?", options[:after]) if options[:after]
    posts = posts.where("id < ?", options[:before]) if options[:before]
    posts = posts.with_image if options[:with_image]
    posts = posts.with_any if options[:with_any]
    #posts = posts.where("file_types LIKE ?", :jpg) if options[:with_image]
    #posts = posts.where("file_types NOT NULL") if options[:with_any]
    #posts = posts.with_audio if options[:with_audio]
    #posts = posts.with_office if options[:with_office]
    #posts = posts.with_other if options[:with_other]
    posts = posts.mentioned(user.username) if options[:mentioned]
    #
    if !source#5 queries
      posts = posts.where(:user_id=>user.id)
      hash[:users_id] = users_id
    elsif options[:mentioned]
      hash[:users_id] = posts.collect(&:user_id)
    else #7 queries
      ignored_subjects_ids, users_id = [], [user.id]
      source.each do |relation|
        #ignored_subjects_ids |= relation.ignored_subjects
        users_id << relation.user2_id
      end
      hash[:users_id] = users_id
      posts = posts.where("user_id IN (?)", users_id)
      #posts = posts.where("subject_id IS NULL OR subject_id NOT IN (?)", ignored_subjects_ids) if ignored_subjects_ids.length > 0
    end
    hash[:posts] = posts
    hash
  end




  def self.from_home(user, source, options={})
    user = User.find(user) unless user.is_a? User
    posts = user.posts.limit(post_size_limit).order("id DESC").after(options[:after]).before(options[:before])

    source_data = user.followings  if source == :followings
    source_data = user.friends     if source == :friends
    
    #ignored_subjects_ids, users_id = [], [user.id]
    users_id = [user.id]
    source_data.each do |relation|
      #ignored_subjects_ids |= relation.ignored_subjects
      users_id << relation.user2_id
    end
    hash = {}
    hash[:users_id] = users_id
    posts = posts.where("user_id IN (?)", users_id)
    
    hash = {:posts => posts}
  end

  def self.from_user(user, options={})
    user = User.find(user) unless user.is_a? User
    posts = user.posts.limit(post_size_limit).order("id DESC").after(options[:after]).before(options[:before])
    
    posts = posts.with_image if options[:with_image]
    posts = posts.with_any if options[:with_any]
    hash = {:posts => posts}
  end
  
  def self.new_search(text, options={})
    return nil unless text && text.length > 2
    text = text.downcase
    
    #basics
    posts = Post.limit(post_size_limit).order("id DESC").after(options[:after]).before(options[:before])
    
    #checking mentioned
    #if options[:mentioned] || User.is_username?(text)
    return hash = {:posts => posts.mentioned(text)} if User.is_username?(text)
    #if not a mention search
    user_ids = User.where("lower(username)=:text OR lower(full_name) LIKE :text", :text=>"%#{text}%").select(:id).collect(&:id)
    posts = posts.where('lower(body) LIKE :text OR lower(links) LIKE :text OR user_id IN (:user_ids)', :text=>"%#{text}%", :user_ids => user_ids)
    hash = {:posts => posts}
  end
  
end
