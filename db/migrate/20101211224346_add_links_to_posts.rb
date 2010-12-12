class AddLinksToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :links, :string
  end

  def self.down
    remove_column :posts, :links
  end
end
