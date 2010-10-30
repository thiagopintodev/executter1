module HomeHelper

  def my_settings_tabs(index)
    options = {"Profile"=>"/conf/1",
      "Account"=>"/conf/2",
      "Design"=>"/conf/3",
      "Picture"=>"/conf/4"#,
      #"Subjects"=>"/conf/5"
      }
      
      
      i=0
      html = ""
      options.each do |name,url|
        html += i==index ? "<li class='atual'>#{name}</li>" : "<li><a href='#{url}'>#{name}</a></li>"
        i+=1
      end
      raw "<ul id='abas-settings'>#{html}</ul>"
  end
  
  def my_orange_errors(errors)
    return if !errors || errors.size == 0
    
    html = "<ul class='alert-settings'>"
    errors.each do |k,v|
      html += "<li><img src='/images/layout1/havatar16x16.jpg' /><a href='#user_#{k}'>#{k}</a>: #{v}</li>"
    end
    
    raw "#{html}</ul>"
  end

end
