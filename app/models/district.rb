# == Schema Information
#
# Table name: districts
#
#  gid      :integer          not null, primary key
#  state    :string(2)
#  cd       :string(3)
#  name     :string(100)
#  the_geom :string           multi_polygon, -1
#  level    :string(255)
#

# Schema explanation:
#     gid           - Postgres-assigned id
#     state         - FIPS code
#     name          - District name. Most are like "029" but some have crazy english names.
#     cd            - District code. Often equivalent to name (district name), but not always. Not exposed in the api but it can be handy for matching up part of different data sets.
#     level         - "state_lower", "state_upper", or "federal".
#     the_geom

class District < ActiveRecord::Base
  self.primary_key = "gid"

  COLORS = {
    'federal' => 'red',
    'state_upper' => 'green',
    'state_lower' => 'blue'
  }.freeze

  DESCRIPTION = {
    'federal' => 'Congressional District',
    'state_upper' => 'Upper House District',
    'state_lower' => 'Lower House District'
  }.freeze

  named_scope :lookup, lambda {|lat, lng|
    {:conditions => ["ST_Contains(the_geom, GeometryFromText('POINT(? ?)', -1))",lng.to_f,lat.to_f]}
  }

  def polygon
    @polygon ||= self.the_geom[0]
  end

  def color
    COLORS.fetch(self.level)
  end

  def state_name
    FIPS_CODES[self.state]
  end

  def display_name
    if /^\d*$/ =~ name
      "#{state_name} #{name.to_i.ordinalize}"
    else
      "#{state_name} #{name}"
    end
  end

  def full_name
    "#{display_name} #{DESCRIPTION.fetch(level)}"
  end

  FIPS_CODES = {
    "01" => "AL",
    "02" => "AK",
    "04" => "AZ",
    "05" => "AR",
    "06" => "CA",
    "08" => "CO",
    "09" => "CT",
    "10" => "DE",
    "11" => "DC",
    "12" => "FL",
    "13" => "GA",
    "15" => "HI",
    "16" => "ID",
    "17" => "IL",
    "18" => "IN",
    "19" => "IA",
    "20" => "KS",
    "21" => "KY",
    "22" => "LA",
    "23" => "ME",
    "24" => "MD",
    "25" => "MA",
    "26" => "MI",
    "27" => "MN",
    "28" => "MS",
    "29" => "MO",
    "30" => "MT",
    "31" => "NE",
    "32" => "NV",
    "33" => "NH",
    "34" => "NJ",
    "35" => "NM",
    "36" => "NY",
    "37" => "NC",
    "38" => "ND",
    "39" => "OH",
    "40" => "OK",
    "41" => "OR",
    "42" => "PA",
    "44" => "RI",
    "45" => "SC",
    "46" => "SD",
    "47" => "TN",
    "48" => "TX",
    "49" => "UT",
    "50" => "VT",
    "51" => "VA",
    "53" => "WA",
    "54" => "WV",
    "55" => "WI",
    "56" => "WY",
    #non-states follow
    "60" => "AS",
    "64" => "FM",
    "66" => "GU",
    "68" => "MH",
    "69" => "MP",
    "70" => "PW",
    "72" => "PR",
    "74" => "UM",
    "78" => "VI"
  }
  STATES = FIPS_CODES.invert.freeze
end

