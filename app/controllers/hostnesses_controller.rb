class HostnessesController < ApplicationController

  before_filter :my_admin_only
  layout "admin"

  def form_vars
    @user_hosts = User.where(:is_host=>true)
    #@user_cities = User.select("DISTINCT(first_geo_city)")
    #@user_states = User.select("DISTINCT(first_geo_state)")
    #@user_countries = User.select("DISTINCT(first_geo_country)")
  end
  
  # GET /hostnesses
  # GET /hostnesses.xml
  def index
    @hostnesses = Hostness.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hostnesses }
    end
  end

  # GET /hostnesses/1
  # GET /hostnesses/1.xml
  def show
    @hostness = Hostness.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hostness }
    end
  end

  # GET /hostnesses/new
  # GET /hostnesses/new.xml
  def new
    @hostness = Hostness.new
    form_vars

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hostness }
    end
  end

  # GET /hostnesses/1/edit
  def edit
    @hostness = Hostness.find(params[:id])
    form_vars
  end

  # POST /hostnesses
  # POST /hostnesses.xml
  def create
    @hostness = Hostness.new(params[:hostness])

    respond_to do |format|
      if @hostness.save
        format.html { redirect_to(hostnesses_path, :notice => 'Hostness was successfully created.') }
        format.xml  { render :xml => @hostness, :status => :created, :location => @hostness }
      else
        format.html { form_vars; render :action => "new" }
        format.xml  { render :xml => @hostness.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hostnesses/1
  # PUT /hostnesses/1.xml
  def update
    @hostness = Hostness.find(params[:id])

    respond_to do |format|
      if @hostness.update_attributes(params[:hostness])
        format.html { redirect_to(hostnesses_path, :notice => 'Hostness was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { form_vars; render :action => "edit" }
        format.xml  { render :xml => @hostness.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hostnesses/1
  # DELETE /hostnesses/1.xml
  def destroy
    @hostness = Hostness.find(params[:id])
    @hostness.destroy

    respond_to do |format|
      format.html { redirect_to(hostnesses_url) }
      format.xml  { head :ok }
    end
  end
end
