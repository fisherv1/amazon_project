require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RoleCondition do
  before(:each) do
    @role_condition = Factory.build(:role_condition)
  end

  it "should save the correct data" do
    @role_condition.save.should == true  
  end

  it "should always have the condition data" do
    @role_condition.doctype_id = nil
    @role_condition.save.should == false
    @role_condition.errors.on(:doctype_id).should_not be_nil

    @role_condition.doctype_id = ""
    @role_condition.save.should == false
    @role_condition.errors.on(:doctype_id).should_not be_nil
  end

  it "should always have the role data" do
    @role_condition.role_id = nil
    @role_condition.save.should == false
    @role_condition.errors.on(:role_id).should_not be_nil

    @role_condition.role_id = ""
    @role_condition.save.should == false
    @role_condition.errors.on(:role_id).should_not be_nil
  end
  it "should have the valid condition" do
    @role_condition.doctype_id = "-1"
    @role_condition.save.should == false
    @role_condition.errors.on(:doctype_id).should_not be_nil
  end
  it "should have the valid role" do
    @role_condition.role_id = "-1"
    @role_condition.save.should == false
    @role_condition.errors.on(:role_id).should_not be_nil
  end
  it "should have unique doctype for the same role" do
    @doctype = Factory(:master_doc_type)
    @role = Factory(:role)
    @role_condition_1 = RoleCondition.new(:doctype_id => @doctype.id, :role_id => @role.id)
    @role_condition_1.save.should == true
    @role_condition_2 = RoleCondition.new(:doctype_id => @doctype.id, :role_id => @role.id)
    @role_condition_2.save.should == false
    @role_condition_2.errors.on(:doctype_id).should_not be_nil
  end
  it "should belongs to Roles"
  it "should belong to conditions"
end

 