class Xlink < ActiveRecord::Base
  belongs_to :user
  
  def to_param
    file_image? ? "#{self.micro}.jpg" : self.micro
  end
  def to_path
    "/x/#{self.to_param}"
  end
  def get_url
    self.url(me)
  end
  
  validates_attachment_size :file, :less_than => 11.megabytes

  #IMAGE_STYLES = { :me=>["200x800>", :jpg] , :original=>["700x2800>", :jpg] }
  IMAGE_STYLES = { :original=>["700x2800>", :jpg] }
  
  has_attached_file :file,
    MyConfig.paperclip_options(
      lambda { |a| MyConfig::image?(a) ? IMAGE_STYLES : {} }
      #{}
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
    len = rand(11)+5
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a + ['_','-','+','!','*']
    self.micro = ""
    1.upto(len) { |i| self.micro << chars[rand(chars.size-1)] }
  end
  
  before_save :my_before_save
  before_create :generate_micro
  
  def my_before_save
    return unless self.file_image? && self.file_width
    geo = Paperclip::Geometry.from_file(file.to_file(:original))
    self.file_width = geo.width
    self.file_height = geo.height  
  end
end
