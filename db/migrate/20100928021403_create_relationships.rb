class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :user1_id
      t.integer :user2_id
      t.boolean :is_followed, :default=> false
      t.boolean :is_follower, :default=> false
      t.boolean :is_friend, :default=> false
      t.boolean :is_blocked,  :default=> false
      t.boolean :is_blocker,  :default=> false
      t.string :ignored_subjects, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end
