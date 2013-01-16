class DistrictsController < ApplicationController

  def lookup
    @lat = params[:lat]
    @lng = params[:lng]

    if @lat.present? && @lng.present?
      @districts = District.lookup(@lat, @lng)
    end

    respond_to do |type|
      type.js do
        load_google_map
        render :layout => false
      end
      type.html do
        load_google_map
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

  private

  def load_google_map
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)

    unless @districts.blank?
      @map.center_zoom_init([params[:lat], params[:lng]],6)
      envelope = @districts.detect{|d| d.level == 'federal' }.the_geom[0].envelope
      @map = Variable.new("map")

      @center = GLatLng.from_georuby(envelope.center)
      @zoom = @map.get_bounds_zoom_level(GLatLngBounds.from_georuby(envelope))

    else
      @map.center_zoom_init([33, -87],6)
      @message = "That lat/lng is not inside a congressional district"
    end
  end

  def districts_to_json
    if params[:lat].present? && params[:lng].present?
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
    else
      {:error => "You must submit a lat and lng."}
    end
  end

end
