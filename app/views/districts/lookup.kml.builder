xml.instruct!
xml.kml("xmlns" => KML_NS) do
  xml.tag! "Document" do

    xml.tag! "Style", :id => "myStyle" do
      xml.tag! "PolyStyle" do

        xml.color "ffff0000" #format is aabbggrr
        xml.outline 0
      end

    end
    if @districts
      @districts.each do | d |
        xml.tag! "Placemark" do
          xml.description "#{d.level} : #{d.display_name}"

          xml.name d.name
          xml.styleUrl "#myStyle"
          xml << d.polygon.as_kml(:altitude => 2000, :altitude_mode => :relativeToGround)
        end
      end
    end
  end
end