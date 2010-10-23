class AddCountersToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :count_of_followings, :integer, :default => 0
    add_column :users, :count_of_followers, :integer, :default => 0
    add_column :users, :count_of_friends, :integer, :default => 0
    add_column :users, :count_of_blockings, :integer, :default => 0
    add_column :users, :count_of_blockers, :integer, :default => 0
  end

  def self.down
    remove_column :users, :count_of_blockers
    remove_column :users, :count_of_blockings
    remove_column :users, :count_of_friends
    remove_column :users, :count_of_followers
    remove_column :users, :count_of_followings
  end
end
