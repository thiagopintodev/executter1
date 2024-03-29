class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id
      t.integer :subject_id
      t.string :body
      t.string :remote_ip
      t.boolean :is_public,   :default=>false
      t.boolean :is_deleted,  :default=>true
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
#t.integer :parent_post_id
#t.string :tags
#add these in a later migration
