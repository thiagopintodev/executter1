class UsersCleanup < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :relations_hash_count
      t.remove :subjects_count, :temp,
        :posts_file_count, :posts_image_count, :first_ip,
        :first_geo_city, :first_geo_state, :first_geo_country,
        :count_of_followings, :count_of_followers, :count_of_friends, :count_of_blockings, :count_of_blockers
    end
    puts "updating users now"
    User.all.collect(&:update_relationship_counters)
  end

  def self.down
    puts "please don't come back from this"
  end
end
