class Page < ActiveRecord::Base
  translates :body
end
=begin
body = "<ul id=\"box-infos\">\r\n      \t"
    3.times do |i|
      body+="<li class=\"titulo\">Dicas #{i}</li>\r\n        <li><span>»</span> Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s</li>"
    end
    body+="\r\n      </ul>"
    Page.create(:key=>'config_profile',:body=>body)
    Page.create(:key=>'config_design',:body=>body)
    Page.create(:key=>'config_subjects',:body=>body)
    Page.create(:key=>'config_picture',:body=>body)
    Page.create(:key=>'config_login',:body=>body)
    puts "added #{Page.count} default translated page contents :)"
=end
