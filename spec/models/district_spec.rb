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

require 'spec_helper'

describe District do

  it "should have a FIPS code lookup table" do
    District::FIPS_CODES['01'].should == 'AL'
  end

  it "should be able to locate by point" do
    districts = District.lookup(41.823989,-71.412834)
    districts.size.should == 71
    districts.select{|d| d.level == 'federal'}.first.display_name.should == 'RI 2nd'
  end

  it "should be able to load a polygon object" do
    p = District.first.polygon
    p.should_not be_nil
  end

  it "should not locate by point when outside of any polygons" do
    districts = District.lookup(-36.158887, 86.782056)
    districts.size.should == 0
  end
end
