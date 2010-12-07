class CreateHostnesses < ActiveRecord::Migration
  def self.up
    create_table :hostnesses do |t|
      t.integer :user_id
      t.string :country
      t.string :state
      t.string :city
      t.string :hostness_type, :default=>Hostness::TYPES.first
      t.boolean :is_active, :default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :hostnesses
  end
end
