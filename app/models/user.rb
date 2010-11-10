# encoding: utf-8
class User < ActiveRecord::Base

  #DEVISE
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable , :lockable

  class << self
    #DEVISE
    def find_for_database_authentication(conditions)
      key = conditions[:email].rindex("@") ? 'email' : 'username'
      where("lower(#{key})=?", conditions[:email].downcase).first
    end

    #CUSTOM METHODS  
    def my_find(param)
      r = (param.to_i > 0) ? where(:id=>param) : where("lower(username)=?", param.downcase.delete("@"))
      r.first
    end

    def username_allowed(username, options={:current_user => nil})
      regex_result = username[USERNAME_REGEX]#validation
      usernamedown = regex_result.downcase
      cu = options[:current_user]
      #
      is_equal_mine = cu.username.downcase==usernamedown if cu#validation
      is_allowed = regex_result && (is_equal_mine || !exists?(:username=>usernamedown))#validation
      {:regular=>regex_result, :allowed=>is_allowed}
    end
  end
  
  def read_photo
    self.photo || Photo.new
  end


  #ATTRIBUTES
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :full_name, :time_zone,
    :email, :password, :password_confirmation, :remember_me, :full_name, :username,
    :gender, :gender_policy, :birth, :birth_policy,
    :background_image, :background_color, :background_position,
    :background_repeat_policy, :background_attachment_policy,
    :flavour, :description,
    :website, :locale, :local,
    :count_of_blockers, :count_of_blockings, :count_of_friends, :count_of_followers, :count_of_followings,
    :subjects_attributes, :posts_count, :subjects_count
  







  #ASSOCIATIONS
  
  belongs_to :photo
  has_many :photos, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :subjects, :dependent => :destroy
  #not used
  has_many :relationships, :class_name => "Relationship", :foreign_key => :user1_id, :dependent => :destroy
  
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
  #HM :dependent => :destroy
  has_many :followers_users,  :through => :followers, :source => :user2
  has_many :followings_users, :through => :followings, :source => :user2
  has_many :blockers_users,   :through => :blockers, :source => :user2
  has_many :blockings_users,  :through => :blockings, :source => :user2
  has_many :friends_users,    :through => :friends, :source => :user2




  #RULES
  
  accepts_nested_attributes_for :subjects, :allow_destroy => true, :reject_if => :all_blank
  
  has_attached_file :background_image, MyConfig.paperclip_options
	validates_attachment_content_type :background_image, :content_type => ['image/jpeg', 'image/gif', 'image/png'] unless :background
  validates_attachment_size :background_image, :less_than => 1.megabytes unless :background


  
#learn css background
#http://maujor.com/tutorial/backtut.php

#learn validation
#http://edgeguides.rubyonrails.org/active_record_validations_callbacks.html
#http://stackoverflow.com/questions/2533502/rails-3-validate-combined-values
#http://www.suffix.be/blog/validate-composite-key-rails3
#http://omgbloglol.com/post/392895742/improved-validations-in-rails-3

  #VALIDATIONS
  validates :username,
    :presence => true, :length => { :in => 2..16 },
    :uniqueness => {:case_sensitive => false}
  validates :full_name,
    :presence => true, :length => { :minimum => 2 }

  #OBSERVERS
  
  after_create :my_after_create
  before_save :my_before_save

  def my_before_save
    self.email = self.email.downcase
  end
  
  def my_after_create
    u = User.find_by_username('executter')
    self.follow u if u
  end

  
  
  #CONSTANTS

  USERNAME_REGEX_NOT = /[^a-zA-Z0-9_-]/
  USERNAME_REGEX = /[a-zA-Z0-9_-]{2,}/
  
  #GENDER_POLICIES = {} #using checkbox
  BACKGROUND_REPEAT_POLICIES = {0=>'no-repeat',1=>'repeat'}#repeat-X, repeat-Y

  GENDERS = {'-'=>'0','model.user.gender.female'=>'1','model.user.gender.male'=>'2'}
  BIRTH_POLICIES = {'model.user.birth_policy.dm'=>0,'model.user.birth_policy.dmy'=>1,'model.user.birth_policy.nothing'=>2}
  LOCALES = {'languages.en' => "en",'languages.pt-BR' => "pt-BR"}

  def self.GENDERS
    MyFunctions.translate_hash_keys(User::GENDERS)
  end
  def self.BIRTH_POLICIES
    MyFunctions.translate_hash_keys(User::BIRTH_POLICIES)
  end
  def self.LOCALES
    MyFunctions.translate_hash_keys(User::LOCALES)
  end


  
  #RELATIONSHIP METHODS
  def follow(u2, value=true)
    Relationship.change('follow', self.id, u2, value)
  end
  def block(u2, value=true)
    Relationship.change('block', self.id, u2, value)
  end
  def toggle_subject(u2, value)
    Relationship.change('subject', self.id, u2, value)
  end


  
  #POST METHODS
  def my_create_post(post_attributes, remote_ip="undefined")
    p = self.posts.build(post_attributes)
    p.post_attachments.each do |pa|
      pa.user_id = self.id
      p.has_image = pa.file? && pa.file_image?
      p.has_file = pa.file? && !pa.file_image?
    end
    p.remote_ip = remote_ip
    p.save ? p : nil
  end
  def my_posts(options={})
    Post.get self, false, options
  end
  def my_followings_posts(options={})
    Post.get self, self.followings, options
  end
  def my_friends_posts(options={})
    Post.get self, self.friends, options
  end

  

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
