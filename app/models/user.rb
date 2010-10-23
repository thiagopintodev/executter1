# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  attr_accessible :full_name, :time_zone,
    :gender, :gender_policy, :birth, :birth_policy,
    :background_image, :background_color, :background_position,
    :background_repeat_policy, :background_attachment_policy,
    :flavour, :description,
    :website, :locale, :local,
    :count_of_blockers, :count_of_blockings, :count_of_friends, :count_of_followers, :count_of_followings

#learn css background
#http://maujor.com/tutorial/backtut.php

#learn validation
#http://edgeguides.rubyonrails.org/active_record_validations_callbacks.html
#http://stackoverflow.com/questions/2533502/rails-3-validate-combined-values
#http://www.suffix.be/blog/validate-composite-key-rails3
#http://omgbloglol.com/post/392895742/improved-validations-in-rails-3
  
  validates :username,
    :presence => true, :length => { :in => 2..16 },
    :uniqueness => {:case_sensitive => false}
  validates :full_name,
    :presence => true, :length => { :minimum => 2 }





  has_attached_file :background_image, MyConfig.paperclip_options
	validates_attachment_content_type :background_image, :content_type => ['image/jpeg', 'image/gif', 'image/png'] unless :background
  validates_attachment_size :background_image, :less_than => 1.megabytes unless :background
  
  before_save :my_before_save

  def my_before_save
    self.email = self.email.downcase
  end
  
  def self.find_for_database_authentication(conditions)
    key = conditions[:email].rindex("@") ? 'email' : 'username'
    where("lower(#{key})=?", conditions[:email].downcase).first
  end

  def self.GENDERS
    {
      '-'=>'0',
      I18n.t('user.gender.female')=>'1',
      I18n.t('user.gender.male')=>'2'
    }
  end

  def self.BIRTH_POLICIES
    {
      I18n.t('user.birth_policy.dm')=>0,
      I18n.t('user.birth_policy.dmy')=>1,
      I18n.t('user.birth_policy.nothing')=>2
    }
  end


  LOCALES = ["en","pt-BR"] #I18n.available_locales.collect(&:to_s)
  BACKGROUND_REPEAT_POLICIES = {0=>'no-repeat',1=>'repeat'}#repeat-X, repeat-Y


  #DEPRECATED because of translations =/
  #GENDERS = {'-'=>'0','user.gender.female'=>'1','user.gender.male'=>'2'}
  #BIRTH_POLICIES = {'user.birth_policy.dm'=>0,'user.birth_policy.dmy'=>1,'user.birth_policy.nothing'=>2}
  #GENDER_POLICIES = {} #using checkbox





  
  def self.my_find(param)
    #return where(:id=>param).first if MyFunctions.number? param
    #where(:username=>param.downcase.delete("@")).first
    r = (param.to_i > 0) ? where(:id=>param) : where("lower(username)=?", param.downcase.delete("@"))
    r.first
  end
  def read_photo
    #posts.scope_photos.last || posts.build
    self.photo || Photo.new
  end
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :username
  validates_presence_of :full_name, :username
  validates_uniqueness_of :username
  
  belongs_to :photo
  has_many :photos
  has_many :posts
  
  #relationships
  #follower:   I'm followed by them     One's a follower for me   So I read them
  #following:  I'm a follower for them  One's followed me         So they reads me
  #blocker:    I'm blocked by them      One's a blocker for me    So I can't follow them
  #blocking:   I'm a blocker for them   One's blocked me          So they can't follow me
  has_many :followers,  :conditions => {:is_followed=>true},  :class_name => "Relationship", :foreign_key => :user1_id
  has_many :followings, :conditions => {:is_follower=>true},  :class_name => "Relationship", :foreign_key => :user1_id
  has_many :friends,    :conditions => {:is_friend=>true},    :class_name => "Relationship", :foreign_key => :user1_id
  has_many :blockers,   :conditions => {:is_blocked=>true},   :class_name => "Relationship", :foreign_key => :user1_id
  has_many :blockings,  :conditions => {:is_blocked=>true},   :class_name => "Relationship", :foreign_key => :user1_id
  #not used
  has_many :relationships, :class_name => "Relationship", :foreign_key => :user1_id
  #HM :dependent => :destroy



  def follow(u2, value=true)
    Relationship.change('follow', self.id, u2, value)
  end
  def block(u2, value=true)
    Relationship.change('block', self.id, u2, value)
  end
  
  def hash_relations(relation, options={})
    #suggestion: make a very generic method using send('followings')
  end

  def followings_posts(options={})
    Post.my_followings(self.id, options)
  end

  def followings_as_hash(options={})
    return @followings_as_hash if @followings_as_hash
    @followings_as_hash = {}
    self.followings.each { |f| @followings_as_hash[f.user2_id] = nil }
    
    #os usuarios deles
    users = User.find(@followings_as_hash.keys)
    
    #preenchidos
    users.each { |u| @followings_as_hash[u.id] = u }
    @followings_as_hash[self.id] = self if options[:and_me]
    return @followings_as_hash
  end

  def followers_as_hash(options={})
    return @followers_as_hash if @followers_as_hash
    @followers_as_hash = {}
    self.followers.each { |f| @followers_as_hash[f.user2_id] = nil }
    
    #os usuarios deles
    users = User.find(@followers_as_hash.keys)
    
    #preenchidos
    users.each { |u| @followers_as_hash[u.id] = u }
    @followers_as_hash[self.id] = self if options[:and_me]
    return @followers_as_hash
  end


  def my_create_post(post_attributes, remote_ip="undefined")
    p = self.posts.build(post_attributes)
    p.post_attachments.each { |pa| pa.user_id = self.id }
    p.remote_ip = remote_ip
    p.save ? p : nil
  end
  
  
  #has_many :executts_i_wrote, :class_name => "Msg",  :conditions => 'created_at > #{10.hours.ago.to_s(:db).inspect}'

  #has_many :subordinates, :class_name => "Employee", :foreign_key => "manager_id"
  #belongs_to :manager, :class_name => "Employee"
  #has_one :account, :include => :representative 

=begin
4.3.1 Methods Added by has_many

When you declare a has_many association, the declaring class automatically gains 13 methods related to the association:

    * collection(force_reload = false)
    * collection<<(object, …)
    * collection.delete(object, …)
    * collection=objects
    * collection_singular_ids
    * collection_singular_ids=ids
    * collection.clear
    * collection.empty?
    * collection.size
    * collection.find(…)
    * collection.exists?(…)
    * collection.build(attributes = {}, …)
    * collection.create(attributes = {})

=end


end
