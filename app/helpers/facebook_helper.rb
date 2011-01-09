module FacebookHelper

  def like(url)
    raw "<iframe src='http://www.facebook.com/plugins/like.php?href=#{url}' scrolling='no' frameborder='0' style='border:none; width:450px; height:80px'><iframe>"
  end

  def activity_feed
    raw "<div style='margin: 10px;'><iframe src='http://www.facebook.com/plugins/activity.php?site=http%3A%2F%2Fexecutter.com&amp;width=240&amp;height=384&amp;header=true&amp;colorscheme=light&amp;recommendations=false' scrolling='no' frameborder='0' style='border:none; overflow:hidden; width:240px; height:384px;background:#fff' allowTransparency='true'></iframe></div>"
  end

end
