class AddCountersToXlinks < ActiveRecord::Migration
  def self.up
    add_column :xlinks, :requests_count, :integer, :default=>0
    Xlink.update_all :requests_count=>0
  end

  def self.down
    remove_column :xlinks, :requests_count
  end
end
