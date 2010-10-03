class BannersController < ApplicationController

  before_filter :my_admin_area, :except=>:index
  layout "admin"

  # GET /banners
  # GET /banners.xml
  def index
    @banners = Banner.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @banners }
    end
  end
=begin
  # GET /banners/1
  # GET /banners/1.xml
  def show
    @banner = Banner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @banner }
    end
  end
=end
  # GET /banners/new
  # GET /banners/new.xml
  def new
    @banner = Banner.new
    

    respond_to do |format|
      format.html { render :form }
      format.xml  { render :xml => @banner }
    end
  end

  # GET /banners/1/edit
  def edit
    @banner = Banner.find(params[:id])
    render :form
  end

  # POST /banners
  # POST /banners.xml
  def create
    @banner = Banner.new(params[:banner])

    respond_to do |format|
      if @banner.save
        format.html { redirect_to(banners_path, :notice => 'Banner was successfully created.') }
        format.xml  { render :xml => @banner, :status => :created, :location => @banner }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @banner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /banners/1
  # PUT /banners/1.xml
  def update
    @banner = Banner.find(params[:id])

    respond_to do |format|
      if @banner.update_attributes(params[:banner])
        format.html { redirect_to(banners_path, :notice => 'Banner was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @banner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /banners/1
  # DELETE /banners/1.xml
  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy

    respond_to do |format|
      format.html { redirect_to(banners_url) }
      format.xml  { head :ok }
    end
  end
end
