class CreateDelayedMailFolloweds < ActiveRecord::Migration
  def self.up
    create_table :delayed_mail_followeds do |t|
      t.integer :user_id
      t.integer :follower_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :delayed_mail_followeds
  end
end
