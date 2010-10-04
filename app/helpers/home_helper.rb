module HomeHelper

  def my_settings_tabs(index)
    options = {"Profile"=>"/conf/1",
      "email, username & password"=>"/conf/2",
      "Picture"=>"/home/settings_picture",
      "Design"=>"/home/settings_design",
      "Notices"=>"/home/settings_notices"}
      
      i=0
      html = ""
      options.each do |name,url|
        html += i==index ? "<li class='atual'>#{name}</li>" : "<li><a href='#{url}'>#{name}</a></li>"
        i+=1
      end
      raw "<ul id='abas-settings'>#{html}</ul>"
  end
  
  def my_orange_errors(model)
    return if resource.errors.size == 0
    
    html = "<ul class='alert-settings'>"
    resource.errors.each do |k,v|
      html += "<li><img src='/images/layout1/havatar16x16.jpg' /><a href='#user_#{k}'>#{k}</a>: #{v}</li>"
    end
    
    raw "#{html}</ul>"
  end

end
