class Photo < ActiveRecord::Base
  belongs_to :user

  has_attached_file :img,
    MyConfig.paperclip_options({
      mi: ["25x25#", :jpg],
      sm: ["50x50#", :jpg],
      me: ["100x100#", :jpg],
      bi: ["200x200#", :jpg]
      })
  
	validates_attachment_content_type :img, :content_type => ['image/jpeg', 'image/gif', 'image/png', 'image/pjpeg', 'image/bmp']
	
end
