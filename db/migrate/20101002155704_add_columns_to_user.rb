class AddColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :username, :string
    add_column :users, :full_name, :string
    add_column :users, :gender, :integer, :default => 0
    add_column :users, :gender_policy, :integer, :default => 0
    add_column :users, :birth, :date, :default => Date.today
    add_column :users, :birth_policy, :integer, :default => 0
    add_column :users, :local, :string, :default => ""
    add_column :users, :locale, :string, :default => "pt-BR"
    add_column :users, :time_zone, :string, :default => "Brasilia"
    add_column :users, :website, :string
    add_column :users, :description, :text
    add_column :users, :photo_id, :integer
    add_column :users, :flavour, :string, :default => "orange"
    add_column :users, :background_repeat_policy, :integer, :default => 0
    add_column :users, :background_attachment_policy, :integer, :default => 0
    add_column :users, :background_color , :string
    add_column :users, :background_position , :string
    
    add_index :users, :username,             :unique => true
  end

  def self.down
    remove_column :users, :background_repeat_policy
    remove_column :users, :background_attachment_policy
    remove_column :users, :background_color
    remove_column :users, :background_position
    remove_column :users, :flavour
    remove_column :users, :photo_id
    remove_column :users, :description
    remove_column :users, :website
    remove_column :users, :time_zone
    remove_column :users, :locale
    remove_column :users, :local
    remove_column :users, :birth_policy
    remove_column :users, :birth
    remove_column :users, :gender_policy
    remove_column :users, :gender
    remove_column :users, :full_name
    remove_column :users, :username
    remove_column :users, :admin
  end
end
