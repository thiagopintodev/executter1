# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  attr_accessible :full_name, :gender, :gender_policy, :birth, :birth_policy,
    :time_zone, :background, :background_repeat_policy, :flavour, :description,
    :website, :locale, :local
    
  attr_accessor :background_color

  validates_length_of :username, :in => 2..16

  has_attached_file :background, MyConfig.paperclip_options
	validates_attachment_content_type :background, :content_type => ['image/jpeg', 'image/gif', 'image/png'] unless :background
  validates_attachment_size :background, :less_than => 1.megabytes unless :background


  def to_t
    self.attributes.each { |k,v| puts "#{k.ljust(30,'.')} #{v || 'nil'}" if v }
    "LAST UPDATE AT: #{updated_at}"
  end
  
  before_save :my_before_save

  def my_before_save
    #User.logger.info('observer before save :))))))))))))))')
    #puts 'observer before save <-------------'
    self.email = self.email.downcase
  end
  
  def self.find_for_database_authentication(conditions)
    key = conditions[:email].rindex("@") ? 'email' : 'username'
    where("lower(#{key})=?", conditions[:email].downcase).first
  end


  #NOW CUSTOM CODE

  LOCALES = ["en","pt-BR"] #I18n.available_locales.collect(&:to_s)
  
  GENDERS = {'-'=>'0','user.gender.female'=>'1','user.gender.male'=>'2'}
  BACKGROUND_REPEAT_POLICIES = {0=>'no-repeat',1=>'repeat'}#repeat-X, repeat-Y
  BIRTH_POLICIES = {'user.birth_policy.dm'=>0,'user.birth_policy.dmy'=>1,'user.birth_policy.nothing'=>2}
  #GENDER_POLICIES = {} #using checkbox
  
=begin
  def full_name=(s)
    name1, name2 = s.split(" ")
  end
  def full_name
    "#{name1} #{name2}"
  end
=end

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
  
  #def name1
  #  full_name.split(" ").first
  #end
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :username
  validates_presence_of :full_name, :username
  validates_uniqueness_of :username
  
  belongs_to :photo
  has_many :photos
  has_many :posts
  has_many :i_relate_to_them, :class_name => "Relationship", :foreign_key => :user1_id
  has_many :they_relate_to_me, :class_name => "Relationship", :foreign_key => :user2_id
  
  
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
