class AddUsernamesToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :usernames, :string
    #add_column :posts, :sea, :text
    Post.all.collect(&:save)#it will invoke before_save filter
  end

  def self.down
    #remove_column :posts, :sea
    remove_column :posts, :usernames
  end
end
