class Devise::RegistrationsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  include Devise::Controllers::InternalHelpers

  # GET /resource/sign_up
  def new
    #return redirect_to profile_path("executter") if !params[:forno] && MyConfig.production?
    build_resource({})
    render_with_scope :new
  end

  # POST /resource/sign_up
  def create
    build_resource
    location = MyGeoKit.geocode(request.remote_ip)
    resource.local = location.city
    
    resource.temp = {:follow_on_registration => cookies[:follow_on_registration]} if cookies[:follow_on_registration]

    did = Rails.env.development? || verify_recaptcha(:model => resource, :message => 'Error at reCAPTCHA!')
    
    if did && resource.save
      #set_flash_message :notice, :signed_up
      #sign_in_and_redirect(resource_name, resource)
      sign_in(resource_name, resource)
      redirect_to(h_after_sign_up_path)
    else
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end

  # GET /resource/edit
  def edit
    render_with_scope :edit
  end

  # PUT /resource
  def update
    #not anymore used
    if resource.update_with_password(params[resource_name])
      #set_flash_message :notice, :updated
      redirect_to request.referer #after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    #set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end

  protected

    # Authenticates the current scope and gets a copy of the current resource.
    # We need to use a copy because we don't want actions like update changing
    # the current user in place.
    def authenticate_scope!
      send(:"authenticate_#{resource_name}!")
      self.resource = resource_class.find(send(:"current_#{resource_name}").id)
    end
end
