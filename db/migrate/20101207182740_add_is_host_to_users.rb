class AddIsHostToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_host, :boolean
    add_column :users, :first_ip, :string
    add_column :users, :first_geo_city, :string
    add_column :users, :first_geo_state, :string
    add_column :users, :first_geo_country, :string
    #add_column :users, :first_geo_zip, :string
    #add_column :users, :first_geo_street, :string

    User.all.each do |u|
      u.first_ip = u.last_sign_in_ip
      u.update_geo
    end
  end

  def self.down
    remove_column :users, :is_host
    remove_column :users, :first_ip
    remove_column :users, :first_geo_city
    remove_column :users, :first_geo_state
    remove_column :users, :first_geo_country
    #remove_column :users, :first_geo_zip
    #remove_column :users, :first_geo_street
  end
end
