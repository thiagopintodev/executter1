class AddTempToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :temp, :string
    add_column :users, :posts_file_count, :integer, :default => 0
    add_column :users, :posts_image_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :temp
    remove_column :users, :posts_file_count
    remove_column :users, :posts_image_count
  end
end
