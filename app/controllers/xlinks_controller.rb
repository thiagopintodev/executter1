class XlinksController < ApplicationController

  layout 'admin', :except => :display
  before_filter :my_admin_only, :except => :display

  # GET /xlinks/1
  # GET /xlinks/1.xml
  def display
    cache_key = "x/#{params[:micro]}"
    if fragment_exist?(cache_key)
      cached_value = read_fragment(cache_key)
    else
      x = Xlink.where(:micro=>params[:micro]).first || Xlink.new
      cached_value = x.file.url(:original, false)
      write_fragment(cache_key, cached_value)
    end
    redirect_to cached_value
  end
  
  # GET /xlinks
  # GET /xlinks.xml
  def index
    @xlinks = Xlink.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @xlinks }
    end
  end

  # GET /xlinks/1
  # GET /xlinks/1.xml
  def show
    @xlink = Xlink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @xlink }
    end
  end

  # GET /xlinks/new
  # GET /xlinks/new.xml
  def new
    @xlink = Xlink.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @xlink }
    end
  end

  # GET /xlinks/1/edit
  def edit
    @xlink = Xlink.find(params[:id])
  end

  # POST /xlinks
  # POST /xlinks.xml
  def create
    @xlink = Xlink.new(params[:xlink])

    respond_to do |format|
      if @xlink.save
        format.html { redirect_to(@xlink, :notice => 'Xlink was successfully created.') }
        format.xml  { render :xml => @xlink, :status => :created, :location => @xlink }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @xlink.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /xlinks/1
  # PUT /xlinks/1.xml
  def update
    @xlink = Xlink.find(params[:id])

    respond_to do |format|
      if @xlink.update_attributes(params[:xlink])
        format.html { redirect_to(@xlink, :notice => 'Xlink was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @xlink.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /xlinks/1
  # DELETE /xlinks/1.xml
  def destroy
    @xlink = Xlink.find(params[:id])
    @xlink.destroy

    respond_to do |format|
      format.html { redirect_to(xlinks_url) }
      format.xml  { head :ok }
    end
  end
end
