class UpdateDistrictNames < ActiveRecord::Migration
  def self.up
 
    # West Virginia Senate District 8 & 17 will be formatted properly; right now it comes back as District 817.
    execute "UPDATE districts SET name = '8 & 17' WHERE level = 'state_upper' AND state = '54' AND name = '817'"
    
    ## Alaska State Senate districts will no longer be padded with zeroes; i.e. "L", not "00L"
    ("A".."T").to_a.each {|z| execute "UPDATE districts SET name='#{z}' WHERE name = '00#{z}'" }
    
    # Alaska House of Representatives districts will output their numbers, without names; i.e. "40", not "40, Arctic"
    (1..9).to_a.each {|i| execute "UPDATE districts SET name='00#{i}' WHERE name like '#{i},%' AND state = '02'" }
    (10..40).to_a.each {|i| execute "UPDATE districts SET name='0#{i}' WHERE name like '#{i},%' AND state = '02'" }
    
    # New Hampshire House of Representatives districts will list the name first; i.e. "Rockingham 5", not "5, Rockingham County"
    District.find_all_by_state_and_level("33", "state_lower").each do |district|
      execute "UPDATE districts SET name = '#{district.name[/[A-Z|a-z| ]+/].strip.gsub("County", "") + district.name[/\d+/]}' WHERE name = '#{district.name}'"
    end
    
    ## Nevada State Senate district names will be simplified; i.e. "Clark 7", not "Clark County Senatorial District 7"
    District.find_all_by_state_and_level("32", "state_upper").each do |district|
      execute "UPDATE districts SET name = '#{district.name.gsub("County Senatorial District ","").gsub("County Senatorial Distict ", "")}' WHERE name = '#{district.name}'"
    end
  end
  
  ALASKA_DISTRICT_NICKNAMES =
  {"015" => "Rural Mat-Su",
   "021" => "Baxter Bog",
   "024" => "Midtown-Taku",
   "034" => "Rural Kenai",
   "035" => "Homer-Seward",
   "038" => "Bethel",
   "007" => "Farmers Loop-Steese Highway",
   "010" => "Fairbanks-Fort Wainwright",
   "009" => "City of Fairbanks",
   "011" => "North Pole",
   "008" => "Denali-University",
   "013" => "Greater Palmer",
   "014" => "Greater Wasilla",
   "040" => "Arctic",
   "006" => "Interior Villages",
   "039" => "Bering Straits",
   "012" => "Richardson-Glenn Highways",
   "016" => "Chugiak-South Mat-Su",
   "018" => "Military",
   "017" => "Eagle River",
   "032" => "Chugach State Park",
   "023" => "Downtown-Rogers Park",
   "020" => "Mountain View-Wonder Park",
   "027" => "Sand Lake",
   "019" => "Muldoon",
   "022" => "University-Airport Heights",
   "026" => "Turnagain-Inlet View",
   "025" => "East Spenard",
   "030" => "Lore-Abbott",
   "029" => "Campbell-Independence Park",
   "028" => "Bayshore-Klatt",
   "031" => "Huffman-Ocean View",
   "033" => "Kenai-Soldotna",
   "004" => "Juneau-Mendenhall Valley",
   "003" => "Juneau-Downtown-Douglas",
   "002" => "Sitka-Wrangell-Petersburg",
   "036" => "Kodiak",
   "005" => "Cordova-Southeast Islands",
   "001" => "Ketchikan",
   "037" => "Bristol Bay-Aleutians"
  }
 
  def self.down
    execute "UPDATE districts SET name = '817' WHERE level = 'state_upper' AND state = '54' AND name = '8 & 17'"
  
    ("A".."T").to_a.each {|z| execute "UPDATE districts SET name='00#{z}' WHERE name = '#{z}'" }
 
    District.find_all_by_state_and_level("33", "state_lower").each do |district|
      execute "UPDATE districts SET name = '#{district.name[/[0-9]+/]}, #{district.name[/[^0-9]+/].strip} County' WHERE name = '#{district.name}'"
    end
 
    District.find_all_by_state_and_level("32", "state_upper").each do |district|
      if ["Clark", "Washoe"].include?(district.name[/[A-Z|a-z]+/])
        execute "UPDATE districts SET name = '#{district.name[/[A-Z|a-z]+/]} County Senatorial District #{district.name[/[0-9]+/]}' WHERE name = '#{district.name}'"
      end
    end
  
    ALASKA_DISTRICT_NICKNAMES.each do |num, name|
      execute "UPDATE districts SET name = '#{num.to_i.to_s}, #{name}' WHERE name = '#{num}'"
    end
  
  end
end
