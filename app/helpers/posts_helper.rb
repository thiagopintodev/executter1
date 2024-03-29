module PostsHelper
  
=begin
w.starts_with?('www')
w: '@username...'
a: 'username...'
b: 'username'
c: '...'
d: '@username'
=end
  def my_post_links(s)
    s = s.gsub("\r"," ")
    at = "@"
    sharp = "#"
    r = s.split(" ").collect do |w|
      if w[0,1]==at
        a = w[1..-1]
        b = a.gsub(User::USERNAME_REGEX_NOT,'')
        c = a.gsub(b,'')
        d = "@#{b}"
        e = "/#{b}"
        "#{link_to(d, e)}#{c}"
      elsif w[0,1]==sharp
        link_to(w, "/s#{w}", :class=>:hash_tag)
      elsif w[0..2] == 'www' || w[0..6]=='http://' || w[0..5]=='ftp://' || w[0..7]=='https://'
        w2 = "http://#{w}" if w[0..2] == 'www'
        link_to w, w2||w, :target=>'_blank'
      else
        w
      end
    end
    raw r.join(" ")
  end

  def my_post_actions(post)
    html = "<li class='icons' style='display:none'>"
    html += link_to image_tag("/images/layout/trash_icon.png", :alt=>""), post, :confirm => 'delete?', :method => :delete, :title=>'Remove', :remote=>true if !post.new_record? && current_user && (post.user_id == current_user.id || current_user.admin)
    html += link_to image_tag("/images/layout/write_icon.png", :alt=>""), "#", :title=>'Mention', :"data-mention"=>post.user.username
    raw "#{html}</li>"
  end
  def file_type(filename)
    MyF.file_type(filename)
  end




=begin
"<img src='/images/layout/trash_icon.png' border='0' />"
  <a href="#" class="nao-clique"><img src="/images/layout/write_icon.png" width="16" height="16" alt="Name" border="0" /></a>
  <%= link_to raw("<img src='/images/layout/trash_icon.png' border='0' />"), post, :method => :delete, :remote=>true if post.user_id == current_user.id %>
  <%=  %>
  <a href="#" class="nao-clique"><img src="/images/layout/execut_icon.png" width="16" height="16" alt="Name" border="0" /></a>
  <a href="#" class="nao-clique"><img src="/images/layout/list_icon.png" width="16" height="16" alt="Name" border="0" /></a>
  <%= link_to raw("<img src='/images/layout/trash_icon.png' border='0' />"), post, :confirm => 'Are you sure?', :method => :delete, :remote=>true %>
  <a href="#" class="delete-post"><img src="/images/layout/trash_icon.png" width="16" height="16" alt="Name" border="0" /></a>
=end  
end
