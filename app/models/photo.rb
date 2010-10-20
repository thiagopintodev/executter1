class Photo < ActiveRecord::Base
  belongs_to :user

  has_attached_file :img,
    MyConfig.paperclip_options({ mi: "25x25#", sm: "50x50#", me: "100x100#", bi: "200x200#"  })
  
	validates_attachment_content_type :img, :content_type => ['image/jpeg', 'image/gif', 'image/png']
	
end
