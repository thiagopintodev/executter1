module PostsHelper
  
  def my_post_links(s)
    at = "@";
    r = s.split(" ").collect { |w| w[0,1]==at ? link_to(w, "/#{w[1..-1]}") : w }
    raw r.join(" ");
  end

  def my_post_actions(post)
    html = "<li class='icons'>"
    html += link_to image_tag("/images/layout/write_icon.png"), "#", :"data-mention"=>post.user.username
    html += link_to image_tag("/images/layout/trash_icon.png"), post, :method => :delete, :remote=>true if post.user_id == current_user.id
    #html = 
    raw "#{html}</li>"
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
