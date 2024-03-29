class MyF
  class << self
  
    def file_type(filename)
      last = filename.downcase.split('.').last
      return :jpg if "jpg|jpeg|gif|bmp|png|psd".include? last
      return :mp3 if "mp3|wav".include? last
      return :pdf if "pdf".include? last
      return :zip if "zip|rar|gz|tar|7z".include? last
      return :doc if "docx".include? last
      return :xls if "xlsx".include? last
      return :ppt if "pptx|ppsx".include? last
      :other
    end
    
    def production?
      ENV['BUCKET_NAME'] == 'production'
    end

    def model(models)
      models.to_yaml.split("\n").each {|a| puts a}; puts ""
    end
    
  end
end
