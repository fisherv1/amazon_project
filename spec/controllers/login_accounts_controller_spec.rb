require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginAccountsController do
   before(:each) do
    @primary_list = Factory(:primary_list)
    @login_account = Factory.build(:login_account)
    @password = "password"
    @login_account.password = @password
    @login_account.save
    @person = Factory(:john)
    LoginAccount.stub(:find).and_return(@login_account)
   end

  def post_create(options = {})
    options[:person_id] ||= @person.id
    options[:password] ||= "password"
    post :create, options
  end

  describe "POST 'create'" do
    before(:each)do
      LoginAccount.stub!(:new).and_return(@login_account)
    end

    it "should find the right person for the new account" do
       
    end
    
  end



























end