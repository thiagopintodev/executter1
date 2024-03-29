class MyConfig
  def self.s3_credentials
    Rails.env.production? ? "#{RAILS_ROOT}/config/s3.yml" : nil
  end

  def self.env
    ENV.each { |k,v| puts "#{k}: #{v}" }
  end
  def self.mime
    puts PostAttachment.select(:file_content_type).all.collect(&:file_content_type).uniq
  end
  
  def self.bucket_name
    #heroku config:add BUCKET_NAME=staging --app 
    ENV['BUCKET_NAME'] || 'development'
  end
  
  def self.production?
    ENV['BUCKET_NAME'] == 'production'
  end
  
  def self.app_name
    ENV['APP_NAME'] || 'cavalinho'
  end

  def self.image?(at)
    #['image/jpeg', 'image/gif', 'image/png'].include? at.content_type
    !!at.content_type.rindex('image') #may return nil, witch means false :)
  end
  def self.music?(at)
    ['application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3'].include? at.content_type
  end
  def self.pdf?(at)
    at.content_type=='application/pdf'
  end
  
  def self.paperclip_options(styles={})
    r = {}
    r[:default_url] = "/images/application/default/:class/:attachment/:style.png"
    r[:styles] = styles
    path = "/#{app_name}/:class/:attachment/:id_partition/:id_:style_:basename.:extension"
    
    if s3_credentials
      r[:storage] = :s3
      r[:s3_credentials] = s3_credentials
      r[:bucket] = "of7_#{bucket_name}"
      r[:path] = path
    else
		  r[:path] = ":rails_root/public/assets#{path}"
		  r[:url] = "/assets#{path}"
    end
    r
  end
  
  def self.paperclip_xlink_options(styles)
    r = {}
    r[:default_url] = "/images/application/default/:class/:attachment/:style.png"
    r[:styles] = styles
    #path = "/#{app_name}/:class/:attachment/:micro.:extension"
    path = "/#{app_name}/box/:micro/:basename.:extension"
    
    if s3_credentials
      r[:storage] = :s3
      r[:s3_credentials] = s3_credentials
      r[:bucket] = "of7_#{bucket_name}"
      r[:path] = path
    else
		  r[:path] = ":rails_root/public/assets#{path}"
		  r[:url] = "/assets#{path}"
    end
    r
  end

end
