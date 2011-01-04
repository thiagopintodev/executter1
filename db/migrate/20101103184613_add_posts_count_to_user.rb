class AddPostsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :posts_count, :integer, :default => 0
    add_column :users, :subjects_count, :integer, :default => 0
    add_column :subjects, :posts_count, :integer, :default => 0
    User.select(:id).includes(:posts, :subjects).each do |u|
      User.update_counters u.id, :posts_count=>u.posts.length, :subjects_count => u.subjects.length
    end
    Subject.select(:id).includes(:posts).each do |s|
      Subject.update_counters s.id, :posts_count=>s.posts.length
    end
  end

  def self.down
    remove_column :users, :posts_count
    remove_column :subjects, :posts_count
  end
end
