class SiteController < ApplicationController
  def index
    return redirect_to home_index_path if current_user
  end

  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    redirect_to request.referer
  end
end
