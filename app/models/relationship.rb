class Relationship < ActiveRecord::Base
  belongs_to :user1, :class_name => "User", :foreign_key => "user1_id"
  belongs_to :user2, :class_name => "User", :foreign_key => "user2_id"
  validates :user1_id, :presence => true
  validates :user2_id, :presence => true
  validate :cant_relate_to_self

  serialize :ignored_subjects
  before_create :my_before_create
  
  def my_before_create
    self.ignored_subjects = [] if self.ignored_subjects == nil
  end
  
  def cant_relate_to_self
    errors.add(:user1_id, "one can't make a relationship with themselves") if user1_id == user2_id
  end

  def self.my_find(u1,u2)
    #u1, u2 = users_id(u1, u2)
    find_by_user1_id_and_user2_id(u1, u2) || new(:user1_id => u1, :user1_id => u1)
  end

  def self.change(property, u1, u2, value, options={})
    u1, u2 = MyFunctions.users_ids([u1, u2])
    r = self.change_block u1, u2, value, options if property == 'block'
    r = self.change_follow u1, u2, value, options if property == 'follow'
    r = self.change_subject u1, u2, value, options if property == 'subject'
    #update_user_counters(u1, u2) if r
    r || property
  end

  def ignoring?(subject_id)
    ignored_subjects.include?(subject_id.to_s)
  end

  protected

  class << self
    def change_block(u1, u2, value, options={})
      rr = my_find_both(u1, u2)
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
    
    def change_follow(u1, u2, value, options={})
      rr = my_find_both(u1, u2)
      r1, r2 = rr[:r1], rr[:r2]
      return if r1.is_blocked
      didnt_follow = !r1.is_follower
      #transaction-begin
      r1.is_follower = r2.is_followed = value
      r1.is_friend = r2.is_friend = false
      r1.is_friend = r2.is_friend = true  if r1.is_follower && r1.is_followed
      return false unless r1.save && r2.save
      #transaction-end
      now_follows = r1.is_follower
      DelayedMailFollowed.create(:user_id=>r1.user2_id, :follower_user_id=>r1.user1_id) if (didnt_follow and now_follows)
        #m = EventMailer.followed r1
        #m.deliver
      #end
      r1
    end
    
    def change_subject(u1, u2, value, options={})
      r1 = my_find(u1, u2)
      return if r1.is_blocked || !r1.is_follower
      #transaction-begin
      if r1.ignoring? value
        r1.ignored_subjects.delete value
      else
        r1.ignored_subjects << value
      end
      r1 if r1.save
      #transaction-end
    end

    #deprecated
    def update_user_counters(*user_ids)
      #I'm perfectly aware of how counter cache columns work in rails :)
      #are integers
      #users = User.find(user_ids)
      user_ids.each do |user_id|
        a = {} #:validate => false
        a[:count_of_blockers]   = where(:user1_id=>user_id, :is_blocked=>true).size
        a[:count_of_blockings]  = where(:user1_id=>user_id, :is_blocker=>true).size
        a[:count_of_followers]  = where(:user1_id=>user_id, :is_followed=>true).size
        a[:count_of_followings] = where(:user1_id=>user_id, :is_follower=>true).size
        a[:count_of_friends]    = where(:user1_id=>user_id, :is_friend=>true).size
        User.update(user_id, a)
      end
    end
    
    
    def my_find_both(u1, u2)
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
end
