class Relationship < ActiveRecord::Base
  belongs_to :user1, :class_name => "User", :foreign_key => "user1_id"
  belongs_to :user2, :class_name => "User", :foreign_key => "user2_id"
  validates :user1_id, :presence => true
  validates :user2_id, :presence => true

  validate :cant_relate_to_self

  def cant_relate_to_self
    errors.add(:user1_id, "one can't make a relationship with themselves") if user1_id == user2_id
  end

  def subjects_ignored=(value)
    self.subjects_ignored_field = value.join(',')
  end
  def subjects_ignored
    self.subjects_ignored_field.split(',')
  end
  #def subjects_ignored?
  #  !self.subjects_ignored_field.blank?
  #end

  def self.my_find(u1,u2)
    #u1, u2 = users_id(u1, u2)
    find_by_user1_id_and_user2_id(u1, u2) || new(:user1_id => u1, :user1_id => u1)
  end

  def self.change(property, u1, u2, value, options={})
    u1, u2 = MyFunctions.users_ids([u1, u2])
    r = self.change_block u1, u2, value, options if property == 'block'
    r = self.change_follow u1, u2, value, options if property == 'follow'
    update_user_counters(u1, u2) if r
    r || nil
  end
  
  #has_many :i_relate_to_them, :class_name => "Relationship", :foreign_key => :user1_id
  #belongs_to :followers, :counter_cache => true,  :conditions => :is_follow=>true
  #belongs_to :customer, :counter_cache => true,  :conditions => "active = 1"
  #belongs_to :following, :class_name => "User", :foreign_key => :user1_id, :counter_cache => :count_of_followings
  #belongs_to :friend, :class_name => "User", :foreign_key => :user1_id,
  #  :counter_cache => :count_of_friends, :conditions => [".is_friend=true"]
=begin 
  scope :scope_follow, where(:is_follow=>true)
  scope :scope_friend, where(:is_friend=>true)
  scope :scope_block,  where(:is_block=>true)
  scope :scope_followed, where(:is_followed=>true)
  scope :scope_blocked,  where(:is_blocked=>true)
  #@user.they_relate_to_me.scope_follow.includes(:user1,:user2)
=end

  protected
  
  def self.change_block(u1, u2, value, options={})
    rr = Relationship.my_find_both(u1, u2)
    r1, r2 = rr[:r1], rr[:r2]
    #return if r1.is_blocked
    #transaction-begin
    r1.is_blocker = r2.is_blocked = value
    r1.is_friend = r2.is_friend = false
    r1.is_follower = r2.is_follower = false
    r1.is_followed = r2.is_followed = false
    r1 if r1.save && r2.save
    #transaction-end
  end
  
  def self.change_follow(u1, u2, value, options={})
    rr = Relationship.my_find_both(u1, u2)
    r1, r2 = rr[:r1], rr[:r2]
    return if r1.is_blocked
    #transaction-begin
    r1.is_follower = r2.is_followed = value
    r1.is_friend = r2.is_friend = false
    r1.is_friend = r2.is_friend = true  if r1.is_follower && r1.is_followed
    r1 if r1.save && r2.save
    #transaction-end
  end

  def self.update_user_counters(*user_ids)
    #I'm perfectly aware of how counter cache columns work in rails :)
    #are integers
    #users = User.find(user_ids)
    user_ids.each do |user_id|
      a = {:validate => false}
      a[:count_of_blockers]   = where(:user1_id=>user_id, :is_blocked=>true).length
      a[:count_of_blockings]  = where(:user1_id=>user_id, :is_blocker=>true).length
      a[:count_of_followers]  = where(:user1_id=>user_id, :is_followed=>true).length
      a[:count_of_followings] = where(:user1_id=>user_id, :is_follower=>true).length
      a[:count_of_friends]    = where(:user1_id=>user_id, :is_friend=>true).length
      User.update(user_id, a)
    end
  end
  
  
  def self.my_find_both(u1, u2)
    #gotta check witch line below is faster
    #ar = where("(user1_id=:user1 AND user2_id=:user2) OR (user1_id=:user2 AND user2_id=:user1)", :user1=>user1_id, :user2=>user2_id)
    ar = where("user1_id IN (:a) AND user2_id IN (:a)", :a=>[u1, u2]).limit(2)
    
    r = {}
    ar.each { |a| r[ (a.user1_id == u1) ? :r1 : :r2 ] = a }
    r[:r1] = Relationship.new(:user1_id=>u1, :user2_id=>u2) unless r[:r1]
    r[:r2] = Relationship.new(:user1_id=>u2, :user2_id=>u1) unless r[:r2]
    r
    #returns objects not saved to the database if the relationship does not exist
  end

end
