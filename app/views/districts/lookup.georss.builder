xml.instruct!
xml.rss(:version => "2.0", "xmlns:georss" => GEORSS_NS) do

  xml.channel do
    xml.title 'Legislative Districts'
    xml.link(url_for(:action => 'lookup', :only_path => false))

    xml.description "Legislative Districts for #{params[:lat]}, #{params[:lng]}"
    xml << @federal.polygon.envelope.as_georss
    @districts.each do | d |
      xml.item do
        xml.title d.display_name
        xml.description d.level
        xml << d.polygon.as_georss
      end
    end
  end
end