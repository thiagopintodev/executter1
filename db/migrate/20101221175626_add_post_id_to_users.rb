class AddPostIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :post_id, :integer
    User.all.each do |u|
      p = u.posts.last
      u.post_id = p.id and u.save if p
    end
  end

  def self.down
    remove_column :users, :post_id
  end
end
