class DistrictsController < ApplicationController
  
  def lookup
    @lat = params[:lat]
    @lng = params[:lng]
    
    @districts = District.lookup(@lat, @lng) if !@lat.blank? && !@lng.blank?
    if @districts && @districts.any?
      @federal = @districts.find{|d| d.level == 'federal' }
      @upper = @districts.find{|d| d.level == 'state_upper' }
      @lower = @districts.find{|d| d.level == 'state_lower' }
    end
    respond_to do | type |
      type.js do 
        load_google_map
        render :layout => false
      end
      type.html do 
        load_google_map
        render :layout => 'maps' 
      end
      type.xml { render :layout => false}
      type.kml { render :layout => false}
      type.georss { render :layout => false}
      type.json{
        args = { :json => districts_to_json }
        args[:callback] = params[:callback] if params[:callback]
        render args
      }
      
    end
  end
  
  def polygon
    @district = District.find(:first, :conditions =>{ :state => District::STATES[params[:state]], :name => params[:district], :level => params[:level]})

    poly = @district.the_geom[0]
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)

    @zoom = @map.get_bounds_zoom_level(GLatLngBounds.from_georuby(poly.envelope))
    @center = GLatLng.from_georuby(poly.envelope.center)
    @polygon = GPolygon.from_georuby(poly,"#000000",0,0.0,"#ff0000",0.3)
  end
  
  def mdata
    geocoder = Graticule.service(:google).new(Ym4r::GmPlugin::ApiKey.get())
    location = geocoder.locate(params[:args])
    @districts = District.lookup(location.latitude, location.longitude)
    @districts = @districts.find_all{|d| !d.level.blank? }
    render :layout => false
  end
    
  private 
  def load_google_map
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    if @districts 

      @map.center_zoom_init([params[:lat], params[:lng]],6)
      
      federal_poly = @federal.the_geom[0] if @federal
      upper_poly   = @upper.the_geom[0] if @upper
      lower_poly   = @lower.the_geom[0] if @lower
      
      envelope = federal_poly.envelope if @federal

      @map = Variable.new("map")
      
      @polygons = []
      @polygons << GPolygon.from_georuby(federal_poly,"#000000",0,0.0,"#ff0000",0.3) if federal_poly
      @polygons << GPolygon.from_georuby(upper_poly,  "#000000",0,0.0,"#00ff00",0.3) if upper_poly
      @polygons << GPolygon.from_georuby(lower_poly,  "#000000",0,0.0,"#0000ff",0.3) if lower_poly

      if @federal
        @center = GLatLng.from_georuby(envelope.center)
        @zoom = @map.get_bounds_zoom_level(GLatLngBounds.from_georuby(envelope))
      end
      
    else
      @map.center_zoom_init([33, -87],6)
      @message = "That lat/lng is not inside a congressional district"
    end
  end
  
  def districts_to_json
    hash = {
      :lat=>params[:lat],
      :lng=>params[:lng]
    }
    @districts.each do |d|
      hash[d.level] = {
       :state        => d.state_name,
       :district     => d.name,
       :display_name => d.display_name
      }          
    end
    hash
  end
  
end
