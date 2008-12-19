class DistrictsController < ApplicationController
  
  def lookup
    @lat = params[:lat]
    @lng = params[:lng]
    
    @districts = District.lookup(@lat, @lng) if @lat && @lng
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
    end
  end
  
  private 
  def load_google_map
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    if @districts 

      @map.center_zoom_init([params[:lat], params[:lng]],6)
      
      federal_poly = @federal.the_geom[0]
      upper_poly   = @upper.the_geom[0]
      lower_poly   = @lower.the_geom[0] if @lower
      
      envelope = federal_poly.envelope

      @map = Variable.new("map")
      
      @polygons = []
      @polygons << GPolygon.from_georuby(federal_poly,"#000000",0,0.0,"#ff0000",0.3)
      @polygons << GPolygon.from_georuby(upper_poly,  "#000000",0,0.0,"#00ff00",0.3)
      @polygons << GPolygon.from_georuby(lower_poly,  "#000000",0,0.0,"#0000ff",0.3) if lower_poly

      @center = GLatLng.from_georuby(envelope.center)
      @zoom = @map.get_bounds_zoom_level(GLatLngBounds.from_georuby(envelope))
      
    else
      @map.center_zoom_init([33, -87],6)
      @message = "That lat/lng is not inside a congressional district"
    end
  end
  
end