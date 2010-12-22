class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :key
      t.text :body

      t.timestamps
    end
    Page.create_translation_table! :body => :text
  end

  def self.down
    drop_table :pages
    Page.drop_translation_table!
  end
end
