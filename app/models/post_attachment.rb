class PostAttachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates_attachment_size :file, :less_than => 11.megabytes


  IMAGE_STYLES = { :sm=>["50x50#", :jpg], :me=>["100x100#", :jpg] , :bi=>["200x200#", :jpg], :original=>["700x700>", :jpg] }
  
  has_attached_file :file,
    MyConfig.paperclip_options(
      #lambda { |a| MyConfig::image?(a) ? PostAttachment::IMAGE_STYLES : {} }
      {}
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
    return unless self.file_image? && self.file_width
    geo = Paperclip::Geometry.from_file(file.to_file(:original))
    self.file_width = geo.width
    self.file_height = geo.height  
  end
end
