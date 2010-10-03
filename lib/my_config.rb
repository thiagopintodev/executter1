class MyConfig
  def self.s3_credentials
    Rails.env.production? ? "#{RAILS_ROOT}/config/s3.yml" : nil
  end

  def self.env
    ENV.each { |k,v| puts "#{k}: #{v}" }
  end
  
  def self.bucket_name
    #heroku config:add BUCKET_NAME=staging --app 
    ENV['BUCKET_NAME'] || 'development'
  end
  
  def self.app_name
    ENV['APP_NAME'] || 'cavalinho'
  end
  
  
  def self.paperclip_options(styles={})
    r = {}
    r[:default_url] = "/images/application/default/:class/:attachment/:style.png"
    r[:styles] = styles
    
    if s3_credentials
      r[:storage] = :s3
      r[:s3_credentials] = s3_credentials
      r[:bucket] = "of7_#{bucket_name}"
      r[:path] = "/#{app_name}/:class/:attachment/:id_partition/:style.:extension"
    else
		  r[:path] = ":rails_root/public/assets/#{app_name}/:class/:attachment/:id_partition/:style.:extension"
		  r[:url] = "/assets/#{app_name}/:class/:attachment/:id_partition/:style.:extension"
    end
    r
  end

end
