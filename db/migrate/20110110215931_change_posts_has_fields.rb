class ChangePostsHasFields < ActiveRecord::Migration
  def self.up
    add_column :posts, :file_types, :string
    remove_column :posts, :has_file
    remove_column :posts, :has_image
    remove_column :posts, :is_deleted
    remove_column :posts, :is_public
  end
    #rename_column :posts, :has_file, :has_any
    #rename_column :posts, :has_image, :has_jpg
    
=begin
    change_column_default :posts, :has_image, nil
    change_column_default :posts, :has_file, nil
    add_column :posts, :has_mp3, :boolean
    add_column :posts, :has_doc, :boolean
    add_column :posts, :has_xls, :boolean
    add_column :posts, :has_ppt, :boolean
    add_column :posts, :has_pdf, :boolean
    add_column :posts, :has_zip, :boolean
    add_column :posts, :has_other, :boolean
=end
  
  def self.down
    add_column :posts, :has_file, :boolean
    add_column :posts, :has_image, :boolean
    remove_column :posts, :file_types
    add_column :posts, :is_deleted, :boolean, :default => true
    add_column :posts, :is_public, :boolean, :default => false
  end
    #change_column_default :posts, :has_image, false
    #change_column_default :posts, :has_file, false
=begin
    rename_column :posts, :has_any, :has_file
    rename_column :posts, :has_jpg, :has_image
    remove_column :posts, :has_audio
    remove_column :posts, :has_word
    remove_column :posts, :has_slide
    remove_column :posts, :has_pdf
    remove_column :posts, :has_other
=end
end
