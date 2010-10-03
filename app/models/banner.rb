class Banner < ActiveRecord::Base

  has_attached_file :img,
    MyConfig.paperclip_options({  })
  
	validates_attachment_content_type :img, :content_type => ['image/jpeg', 'image/gif', 'image/png']

end
