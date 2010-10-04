module ApplicationHelper
  def my_title(value)
    content_for(:title) { value }
  end
  def my_css_files(*values)
    s = values.collect { |v| stylesheet_link_tag("/layout1/css/#{v}") }
    content_for(:css_files) { s.join }
  end
  def my_flavour_stylesheet(user)
    #s = cookies[:flavour] ||= "orange"
    stylesheet_link_tag "/layout1/css/sabor_#{user.flavour}.css"
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
=begin
  def my_user_links(s)
    at = "@";
    words = s.split(" ");
    r = words.collect { |w| w[0,1]==at ? link_to(w, "/#{w}") : w }
    r.join(" ");
  end
  
  def my_tabs(*tabs)
    content_tag :ul, {:id=>"menu-abas"} do
      tabs.collect do |tab|
        li_content = "<img src='/images/layout/havatar16x16.jpg' width='16' height='16' /> #{tab[:text]}"
        unless tab[:action] == controller.action_name
          li_content = link_to li_content, tab[:path]
        else
          options = {:class=>'atual'}
        end
        content_tag(:li, li_content, options)
      end
    end
  
  end
=end
end
