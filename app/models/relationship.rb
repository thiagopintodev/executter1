class Relationship < ActiveRecord::Base
  belongs_to :user1, :class_name => "User", :foreign_key => "user1_id"
  belongs_to :user2, :class_name => "User", :foreign_key => "user2_id"

  #default_scope where(:is_deleted => false)

  #scope :scope_photos, where("img_file_name IS NOT NULL")
  scope :scope_follow, where(:is_follow=>true)
  scope :scope_friend, where(:is_friend=>true)
  scope :scope_block,  where(:is_block=>true)
  #@user.they_relate_to_me.scope_follow.includes(:user1,:user2)




  # user1_id:integer user2_id:integer is_follow:boolean is_friend:boolean is_block:boolean
  def self.my_find_or_create(user1_id, user2_id)
    find_or_create_by_user1_id_and_user2_id(user1_id, user2_id)
  end






  
  def self.my_find(user1_id, user2_id)
    #ar = where("(user1_id=:user1 AND user2_id=:user2) OR (user1_id=:user2 AND user2_id=:user1)", :user1=>user1_id, :user2=>user2_id)
    ar = where("user1_id IN (:a) AND user2_id IN (:a)", :a=>[user1_id, user2_id])

    #gotta check witch is faster
    
    r = {}
    ar.each do |a|
      k = (a.user1_id == user1_id) ? :r1 : :r2
      r[k] = a
    end
    r[:r1] = Relationship.new(:user1_id=>user1_id, :user2_id=>user2_id) unless r[:r1]
    r[:r2] = Relationship.new(:user1_id=>user2_id, :user2_id=>user1_id) unless r[:r2]
    r
  end


 
  def self.set_block(relations, is_block)
    #r = my_find(user1_id, user2_id)
    r1, r2 = relations[:r1], relations[:r2]
    
    r1.is_block = is_block
    r1.is_follow = false
    r1.is_friend = false
    r1.save
    
    if is_block
      Relationship.logger.info("User##{r1.user1_id} is now blocking User##{r1.user2_id}")
      r2.is_block = false
      r2.is_follow = false
      r2.is_friend = false
      r2.save
    else
      Relationship.logger.info("User##{r1.user1_id} isn't blocking User##{r1.user2_id} anymore")
    end
  end
  
  def self.set_follow(u1, u2, is_follow, options={})
    r = Relationship.my_find(u1, u2)
    r1, r2 = r[:r1], r[:r2]
    return if r2.is_block
    #transaction-begin
    #Relationship.logger.info(r1.attributes)
    #Relationship.logger.info(r2.attributes)
    
    r1.is_follow = is_follow
    r1.is_friend = false && r2.is_friend = false
    r1.is_friend = true  && r2.is_friend = true  if r1.is_follow && r2.is_follow
    r1.save && r2.save

    Post.my_log_follow(u1, u2, options)
    r
    #Relationship.logger.info(r1.attributes)
    #Relationship.logger.info(r2.attributes)
    #transaction-end
  end



  
  
  def self.friend?(r1,r2)
    r1.is_follow and r2.is_follow
  end
  
  def self.my_find_old(user1_id, user2_id)
    find_by_user1_id_and_user2_id(user1_id, user2_id)
  end
end
