class AddInviterToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :inviter_user_id, :integer
  end

  def self.down
    remove_column :users, :inviter_user_id
  end
end
