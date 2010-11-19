#encode: utf-8
module MyGeoKit

  def self.geocode(ip_address)
    unless true || Rails.env.production?
      r = Geokit::GeoLoc.new(:city=>"city",:state=>"state", :lat=>-1, :lng=>-1,:country_code=>"BR")
      r.provider = "not in production"
      r.success=true
      return r
    end
    begin
      r = GeoKit::Geocoders::MultiGeocoder.geocode(ip_address)
      coder = HTMLEntities.new
      r.city = coder.decode(r.city)
      r.state = coder.decode(r.state)
      r
    rescue
      Geokit::GeoLoc.new
    end
  end
  
end
