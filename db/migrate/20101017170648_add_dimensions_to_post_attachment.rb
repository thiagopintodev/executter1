class AddDimensionsToPostAttachment < ActiveRecord::Migration
  def self.up
    add_column :post_attachments, :file_width, :integer, :default => 0
    add_column :post_attachments, :file_height, :integer, :default => 0
  end

  def self.down
    remove_column :post_attachments, :file_height
    remove_column :post_attachments, :file_width
  end
end
