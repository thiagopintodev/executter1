module ApplicationHelper
  def my_title(value)
    content_for(:title) { value }
  end
  def my_css_files(*values)
    s = values.collect { |v| stylesheet_link_tag("/layout1/css/#{v}") }
    raw content_for(:css_files) { s.join }
  end
  def my_flavour_stylesheet
    user = @user || current_user
    #s = cookies[:flavour] ||= "orange"
    s = (user && user.flavour) || "orange"
    stylesheet_link_tag "/layout1/css/sabor_#{s}.css"
  end
  def body_class
    "class='pg-#{controller_name}-#{action_name} group-#{controller_name}'"
  end
  
  def my_flash_keys
    s = flash.keys.collect do |k|
      "<p class='code #{k}'><code>#{flash[k]}</code></p>"
    end
    raw s.join if s.length>0
  end
  
  
  def google_analytics codigo_google_analytics
    if Rails.env.production?
      raw "<script type='text/javascript'>
      var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');
      document.write(unescape('%3Cscript src=' + gaJsHost + 'google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E'));
      </script>
      <script type='text/javascript'>
      try{
      var pageTracker = _gat._getTracker('#{codigo_google_analytics}');
      pageTracker._trackPageview();
      } catch(err) {}
      </script>"
    end
  end
end
