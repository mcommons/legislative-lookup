xml.instruct!
xml.response do
	xml.lat params[:lat]
	xml.lng params[:lng]
	if @districts && @districts.any?
	  @districts.each do | d | 
  		xml.tag!(d.level.intern) do
  			xml.iddd d.gid
  			xml.state d.state_name
  			xml.district d.name
  			xml.display_name d.display_name
  		end
  	end
	else
		if params[:lat] && params[:lng]
			xml.error  "No district found"
		else
			xml.error "Must supply lat and lng parameters"
		end 
	end
end