class DropPostAttachment < ActiveRecord::Migration
  def self.up
    drop_table :post_attachments
  end

  def self.down
    puts "I don't plan to be a getting back from this"
    puts "I didn't delete old PA migrations because I believe they are an important step"
  end
end
