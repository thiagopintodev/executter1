module PostsHelper
  
  def my_post_links(s)
    at = "@";
    r = s.split(" ").collect { |w| w[0,1]==at ? link_to(w, "/#{w[1..-1]}") : w }
    raw r.join(" ");
  end
  
end
