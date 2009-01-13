require File.dirname(__FILE__).gsub(/spec\/.*/,'') + "spec/spec_helper"

describe District do
  
  it "should have a FIPS code lookup table" do 
    District::FIPS_CODES['01'].should == 'AL'
  end
  
  it "should be able to locate by point" do
    districts = District.lookup(36.158887, -86.782056)
    districts.size.should == 3
    districts.select{|d| d.level == 'federal'}.first.display_name.should == 'TN 5th'
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