class Xlink < ActiveRecord::Base
  belongs_to :user
  
  def to_url
    fmt_micro = file_image? ? "#{micro}.jpg" : micro
    MyConfig.production? ? "http://box.executter.com/#{fmt_micro}" : "/x/#{fmt_micro}"
  end
  
  validates_attachment_size :file, :less_than => 11.megabytes
  
  Paperclip.interpolates :micro do |attachment, style|
    attachment.instance.micro
  end
  has_attached_file :file,
    MyConfig.paperclip_xlink_options(
      lambda { |a| MyConfig::image?(a) ? { :original=>["700x2800>", :jpg] } : {} }
    )
  def file_image?
    return false unless file?
    MyConfig::image?(file)
  end
  def file_music?
    MyConfig::music?(file)
  end
  # :processors => lambda { |a| a.video? ? [ :video_thumbnail ] : [ :thumbnail ] }

  def generate_micro
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a + ['_','-','!','*']
    exists = true
    while exists
      self.micro = ""
      5.times { self.micro << chars[rand(chars.size-1)] }
      exists = Xlink.exists?(:micro=>self.micro)
    end
  end
  
  before_save :learn_image_geometry
  before_create :generate_micro
  
  def learn_image_geometry
    return unless self.file_image? && self.file_width
    geo = Paperclip::Geometry.from_file(file.to_file)
    self.file_width = geo.width
    self.file_height = geo.height
  end
end
