require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PeopleController do
  before(:each) do
    @primary_list = Factory(:primary_list)
    @person = Factory.build(:john)
    @attributes = Factory.attributes_for(:john)
    @duplication_formula_appiled = Factory(:personal_duplication_formula)
    PersonalDuplicationFormula.stub!(:applied_setting).and_return(@duplication_formula_appiled)
    Person.stub!(:find).and_return(@person)
    session[:user] = Factory(:login_account).id
  end
  
  def post_create(options = {})
    options[:person] ||= @attributes
    post :create, options
  end

  def post_add_keywords(options ={})
    options[:add_keywords] ||= [1,2]
    post :add_keywords, options
  end
    
  def put_update(options = {})
    options[:id] ||= @person.id
    options[:person] ||= @attributes
    put :update, options
  end

  def get_name_finder(options = {})
    get :name_finder, options
  end

  def get_role_finder(options = {})
    get :role_finder, options
  end

  def get_master_doc_meta_type_finder(options = {})
    get :master_doc_meta_type, options
  end

  def get_master_doc_type_finder(options = {})
    get :master_doc_type_finder, options
  end

  def get_edit(options = {})
    get :edit, options
  end

  def get_show(options = {})
    options[:id] ||= @person.id
    get :show, options
  end
  
  def get_search(options={})
    options[:commit] ||= "Search"
    options[:id] ||= @person.id
    get :search, options
  end

  def get_name_card(options={})
    options[:id] ||= @person.id
    get :name_card, options
  end

  def get_master_doc_meta_type_finder(options={})
    get :master_doc_meta_type_finder, options
  end

  def get_master_doc_type_finder(options={})
    get :master_doc_type_finder, options
  end

  describe "GET 'new'" do
    before(:each) do
    
      get 'new'
    end

    it "should assign a new Person to a variable" do
      assigns[:person].should be_new_record
    end

    it "should assign a new Person with an associate address to a variable" do
      assigns[:person].addresses.length.should == 1
    end

    it "should have a phone associated with a Person" do
      assigns[:person].addresses.length.should == 1
    end
    
    it "should have an email associated with a Person" do
      assigns[:person].addresses.length.should == 1
    end

    it "should render new" do
      response.should render_template('new')
    end
  end

  describe "POST 'create'" do
    context "when params are valid" do
      before(:each) do
        Person.stub!(:new).and_return(@person)
        @person.stub!(:save).and_return(true)
        session[:user] = Factory(:login_account).id
      end
      
      it "should build the person" do
        Person.should_receive(:new).with(hash_including(@attributes)).and_return(@person)
        @person.save
        post_create
      end

      it "should save the person" do
        @person.should_receive(:save).and_return(true)
        post_create
      end

      it "should assign the new record" do
        post_create
        assigns[:person].should == @person
      end

      it "should redirect to new" do
        post_create :commit => "Submit"
        response.should redirect_to(new_person_path)
      end

    end

    context "when params are invalid" do

      before(:each) do
        @invalid = Factory.build(:invalid_person)
        @invalid.emails.build()
        @invalid.addresses.build()
        @invalid.phones.build()
        @invalid.faxes.build()
        @invalid.websites.build()
        Person.stub!(:new).and_return(@invalid)
        @person.stub!(:save).and_return(false)
      end

#      it "should render new if unsucessful" do
#        post_create
#        response.should render_template('new')
#      end

#      it "should flash an error message if unsuccessful" do
#        post_create
#        flash[:warning].should have_at_least(1).things
#      end

    end
  end

  describe "PUT :update" do
    it "should get the request person general info" do
      session[:user] = Factory(:login_account).id
      @person = Factory(:person)
      Person.should_receive(:find).with(@person.id.to_s).and_return(@person)
      put_update :person_id => @person.id
    end

    it "should update the person's attributes" do
      @person.should_receive(:update_attributes).with(hash_including(@attributes)).and_return(true)
      put_update
    end

  end


  describe "PUT :name_finder" do

    before(:each) do
      Person.stub!(:find).and_return(@person)
    end

    it "should find the correctly set @person if params[:person_id] is specified" do
      get_name_finder(:person_id => @person.id)
      assigns[:person].should equal(@person)
    end

    it "should render name_finder" do
      get_name_finder
      response.should render_template('name_finder')
    end

  end

  describe "PUT :role_finder" do

    before(:each) do
      Person.stub!(:find).and_return(@person)
    end

    it "should find the correctly set @person if params[:person_id] is specified" do
      get_role_finder(:person_id => @person.id)
      assigns[:person].should equal(@person)
    end

    it "should render role_finder" do
      get_role_finder
      response.should render_template('role_finder')
    end

  end


  describe "GET 'name_card'" do
    before(:each) do
      Person.stub!(:find).and_return(@person)
    end

    it "should find the person we supply an id for" do
      Person.should_receive(:find).and_return(@person)
      get_name_card
    end

  end

  describe "GET 'master_doc_meta_type_finder'" do
    before(:each) do
      @mdmmt = Factory(:master_doc_meta_meta_type)
      @mdmt_1 = Factory(:master_doc_meta_type, :tag_meta_type_id => @mdmmt.id)
      @mdmt_2 = Factory(:master_doc_meta_type, :tag_meta_type_id => @mdmmt.id)
      @md = Factory(:master_doc)
    end

    it "should find the correct documents" do
      MasterDocMetaType.should_receive(:find).and_return([@mdmt_1, @mdmt_2])
      MasterDoc.should_receive(:find).and_return(@md)
      get_master_doc_meta_type_finder(:id => @mdmmt.id, :master_doc_id => @md.id)
    end
 
  end

  describe "GET 'master_doc_type_finder'" do
    before(:each) do
      @mdmt = Factory(:master_doc_type)
      @mdt_1 = Factory(:master_doc_type, :tag_type_id => @mdmt.id)
      @mdt_2 = Factory(:master_doc_type, :tag_type_id => @mdmt.id)
      @md = Factory(:master_doc)
    end

    it "should find the correct documents" do
      MasterDocType.should_receive(:find).and_return([@mdt_1, @mdt_2])
      MasterDoc.should_receive(:find).and_return(@md)
      get_master_doc_type_finder(:id => @mdmt.id, :master_doc_id => @md.id)
    end

  end


  describe "GET 'show'" do
    before(:each) do
     
    end

  end

  describe "GET 'edit'" do

    before(:each) do
      Person.stub!(:find).and_return(@person)
      Person.stub!(:new).and_return(@person)
    end

    it "should find the correctly set @person if params[:person_id] is specified" do
      get_edit(:person_id => @person.id)
      assigns[:person].should equal(@person)
    end

    it "should generate a new record for @person if there is no params[:person_id] specified" do
      get_edit
      assigns[:person].should be_new_record
    end


  end

  describe "Get 'search'" do
#    context "if params[:commit] != 'Search'" do
#      before(:each) do
#        get_search :commit => 'test'
#      end
#      it { should render_template("search")}
#    end

    context "if params[:commit] == 'Search'" do

      context "if no person was found" do
        before(:each) do
          Person.stub!(:find_all_by_id).and_return([])
          get_search
        end

      end

#      context "if more than one person was found" do
#        before(:each) do
#          Person.stub!(:find_all_by_id).and_return([@person,@person])
#          get_search
#        end
#
#        it {should render_template("people/search.html.haml")}
#      end

      context "only one person was found" do
        before(:each) do
          Person.stub!(:find_all_by_id).and_return([@person])
          get_search
        end

        # it {should redirect_to(person_path(@person))}
      end
    end
  end

 

  
end
