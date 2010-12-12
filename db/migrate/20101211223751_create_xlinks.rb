class CreateXlinks < ActiveRecord::Migration
  def self.up
    create_table :xlinks do |t|
      t.integer :user_id
      t.string :micro
      t.integer :file_width
      t.integer :file_height

      t.timestamps
    end
  end

  def self.down
    drop_table :xlinks
  end
end
