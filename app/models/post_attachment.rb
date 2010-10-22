class PostAttachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  IMAGE_STYLES = { :sm=>["50x50#", :jpg], :me=>["100x100#", :jpg] , :bi=>["200x200#", :jpg] }
  
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

  before_save :my_before_save
  
  def my_before_save
    self.file_width = 100
    self.file_height = 300
  end
end
