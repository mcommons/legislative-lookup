require 'spec_helper'

describe DistrictsController, :type => :controller do
  integrate_views

  it "should load the inital page" do
    get :lookup, :format => 'html'
    response.should be_success
  end

  it "should return no districts if no result" do
    get :lookup, :lat => 36.158887, :lng => -86.782056, :format => 'js'
    response.should be_success
    assigns[:districts].size.should == 0
  end

  it "should allow lookups via ajax" do
    get :lookup, :lat => 41.823989, :lng => -71.412834, :format => 'js'
    response.should be_success
    assigns[:districts].detect{|d| d.level == 'federal' }.display_name.should == 'RI 2nd'
  end

  it "should allow lookups via xml" do
    get :lookup, :lat => 41.823989, :lng => -71.412834, :format => 'xml'
    response.should be_success
  end

  it "should allow lookups via kml" do
    get :lookup, :lat => 41.823989, :lng => -71.412834, :format => 'kml'
    response.should be_success
  end

  it "should allow lookups via georss" do
    get :lookup, :lat => 41.823989, :lng => -71.412834, :format => 'georss'
    response.should be_success
  end

  it "should handle the NE unicameral legislature" do
    get :lookup, :lat => 40.920324, :lng => -98.364636, :format => 'xml'
    response.should be_success
    assigns[:lower].should be_nil
  end

  it "should allow lookups via json" do
    get :lookup, :lat => 41.823989, :lng => -71.412834, :format => 'json'
    response.should be_success
  end

end
