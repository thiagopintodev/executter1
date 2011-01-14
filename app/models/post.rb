class Post < ActiveRecord::Base

  belongs_to :user, :counter_cache=>true
  #belongs_to :subject, :counter_cache=>true
  
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
    MyF.production? ? 10 : 30
  end

  #EVENT METHODS
  before_save :my_before_save
  def my_before_save
    #self.sea = "#{body.downcase} #{links.first.values.join(' ').downcase if links}"
    a = User.usernames_in_text(self.body)
    self.usernames = " #{a.join(' ').downcase} " if a.size > 0
  end



  def self.count_latest_by_user(user_id, time)
    where(:user_id=>user_id).where("created_at > ?", Time.now - time).count
  end
  def self.count_latest_by_remote_ip(remote_ip, time)
    where(:remote_ip=>remote_ip).where("created_at > ?", Time.now - time).count
  end

  #SEARCH METHODS
  def self.from_home(user, source, options={})
    user = User.find(user) unless user.is_a? User
    posts = Post.limit(post_size_limit).order("posts.id DESC").after(options[:after]).before(options[:before])
    
    source = user.followings  if source == :followings
    source = user.friends     if source == :friends
    
    #ignored_subjects_ids, users_id = [], [user.id]
    users_id = [user.id]
    source.each do |relation|
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
    posts = user.posts.limit(post_size_limit).order("posts.id DESC").after(options[:after]).before(options[:before])
    
    posts = posts.with_image if options[:with_image]
    posts = posts.with_any if options[:with_any]
    hash = {:posts => posts}
  end
  
  def self.new_search(text, options={})
    return nil unless text
    text = text.downcase
    
    #basics
    posts = Post.limit(post_size_limit).order("posts.id DESC").after(options[:after]).before(options[:before])
    
    #checking mentioned
    #if options[:mentioned] || User.is_username?(text)
    return hash = {:posts => posts.mentioned(text)} if User.is_username?(text)
    #if not a mention search
    user_ids = User.where("lower(users.username)=:text OR lower(users.full_name) LIKE :text", :text=>"%#{text}%").select(:id).collect(&:id)
    posts = posts.where('lower(posts.body) LIKE :text OR lower(posts.links) LIKE :text OR posts.user_id IN (:user_ids)', :text=>"%#{text}%", :user_ids => user_ids)
    hash = {:posts => posts}
  end
  
end
