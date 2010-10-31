class AddFlagsToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :has_image, :boolean, :default => false
    add_column :posts, :has_file, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :has_file
    remove_column :posts, :has_image
  end
end
