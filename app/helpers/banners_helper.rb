module BannersHelper

  def my_banner
    Banner.first || Banner.new
  end

end
