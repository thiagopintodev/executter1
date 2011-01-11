class MyF
  class << self
    def file_type(filename)
      return :jpg if filename.ends_with? ".jpg"
      return :mp3 if filename.ends_with? ".mp3"
      return :zip if filename.ends_with? ".zip"
      return :pdf if filename.ends_with? ".pdf"
      return :doc if filename.ends_with? ".doc"
      return :xls if filename.ends_with? ".xls"
      return :ppt if filename.ends_with? ".ppt"
      :other
    end
  end
end
