class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :user1_id
      t.integer :user2_id
      t.boolean :is_block,  :default=> false
      t.boolean :is_follow, :default=> false
      t.boolean :is_friend, :default=> false

      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end
