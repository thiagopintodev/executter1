module FacebookHelper

  def like(url)
    raw "<iframe src='http://www.facebook.com/plugins/like.php?href=#{url}' scrolling='no' frameborder='0' style='border:none; width:450px; height:80px'><iframe>"
  end

end
