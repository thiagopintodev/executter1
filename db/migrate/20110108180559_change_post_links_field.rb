class ChangePostLinksField < ActiveRecord::Migration
  def self.up
    h_posts = {}
    Post.all.each { |p| h_posts[p.id] = p.links }
    remove_column :posts, :links
    add_column :posts, :links, :text
    Post.all.each { |p| p.links = h_posts[p.id]; p.save }
  end

  def self.down
    puts "no reason to go back"
  end
end
