class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :type
      t.integer :user_id
      t.integer :parent_post_id
      t.string :body
      t.string :remote_ip
      t.string :tags
      t.boolean :is_public,   :default=>false
      t.boolean :is_deleted,  :default=>true
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
