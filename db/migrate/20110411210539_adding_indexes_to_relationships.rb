class AddingIndexesToRelationships < ActiveRecord::Migration
  def self.up
    #RELATIONSHIPS
    #find_both
    add_index :relationships, [:user1_id, :user2_id]
    #tab posts
    add_index :relationships, [:user1_id, :user2_id, :is_follower]
    add_index :relationships, [:user1_id, :user2_id, :is_followed]
    #USERS
    add_index :users, [:id, :username, :full_name, :photo_id]
  end

  def self.down
    #RELATIONSHIPS
    #find_both
    remove_index :relationships, [:user1_id, :user2_id]
    #tab posts
    remove_index :relationships, [:user1_id, :user2_id, :is_follower]
    remove_index :relationships, [:user1_id, :user2_id, :is_followed]
    #USERS
    remove_index :users, [:id, :username, :full_name, :photo_id]
  end
end
