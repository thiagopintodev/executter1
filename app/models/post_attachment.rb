class PostAttachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  IMAGE_STYLES = { :sm=>"50x50#", :me=>"100x100#" , :bi=>"200x200#" }
  
  has_attached_file :file,
    MyConfig.paperclip_options(
      lambda { |a| MyConfig::image?(a) ? PostAttachment::IMAGE_STYLES : {} }
    )
  def file_image?
    MyConfig::image?(file)
  end
  def file_music?
    MyConfig::music?(file)
  end
  # :processors => lambda { |a| a.video? ? [ :video_thumbnail ] : [ :thumbnail ] }

end
