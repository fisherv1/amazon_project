require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Website do
  before(:each) do
    @primary_list = Factory(:primary_list)
    @website = Factory.build(:website)
    @attributes = Factory.build(:website)
  end

  # No longer used / needed
  # it {should belong_to(:contactable)}
  
  it "should return the address" do
    @website.address.should == @attributes[:value]
  end
  
  it "should save a new record as a primary website if there is no phone belongs to contactable" do
    @website.contactable.websites.clear
    @website.save!
    @website.priority_number.should == 1
  end
end
