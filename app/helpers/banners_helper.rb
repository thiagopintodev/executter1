module BannersHelper

  def my_banner
    a = Banner.all_displaying.sort_by { rand } unless @my_banner
    @my_banner ||= a.first || Banner.new
  end

end
