require File.dirname(__FILE__).gsub(/spec\/.*/,'') + "spec/spec_helper"

describe DistrictsController do
  integrate_views
  
  it "should load the inital page" do
    get :lookup, :format => 'html'
    response.should be_success
  end
  
  it "should allow lookups via ajax" do
    get :lookup, :lat => 36.158887, :lng => -86.782056, :format => 'js'
    response.should be_success
    assigns[:districts].size.should == 3
    assigns[:upper].should_not be_nil
    assigns[:lower].should_not be_nil
    assigns[:federal].display_name.should == 'TN 5th'
  end
  
  it "should allow lookups via xml" do
    get :lookup, :lat => 36.158887, :lng => -86.782056, :format => 'xml'
    response.should be_success
  end
  
  it "should allow lookups via kml" do
    get :lookup, :lat => 36.158887, :lng => -86.782056, :format => 'kml'
    response.should be_success
  end
  
  it "should allow lookups via georss" do
    get :lookup, :lat => 36.158887, :lng => -86.782056, :format => 'georss'
    response.should be_success
  end
  
  it "should handle the NE unicameral legislature" do
    get :lookup, :lat => 40.920324, :lng => -98.364636, :format => 'xml'
    response.should be_success
    assigns[:lower].should be_nil
  end

  it "should allow lookups via json" do
    get :lookup, :lat => 36.158887, :lng => -86.782056, :format => 'json'
    response.should be_success
  end

end
