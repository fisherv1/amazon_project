class TransactionsController < ApplicationController
  # System Log stuff added

  def personal_transaction
    session[:module] = "receipting"
    @group_types = LoginAccount.find(session[:user]).group_types
    @list_headers = @current_user.all_lists
    @list_header = ListHeader.find(session[:current_list_id])
    @p = @list_header.people_on_list
    @person = Person.find(session[:current_person_id])
    session[:entity_type] = "Person"
    session[:entity_id] = @person.id
    respond_to do |format|
      format.html
    end
  end

  def organisational_transaction
    session[:module] = "receipting"
    @organisation = Organisation.find(session[:current_organisation_id])
    @o = Organisation.find(:all, :order => "id")
    session[:entity_type] = "Organisation"
    session[:entity_id] = @organisation.id
    respond_to do |format|
      format.html
    end
  end

  def new
    @system_date = session[:clocktime].strftime("%d-%m-%Y")
    @transaction_header = TransactionHeader.new
  end

  def edit
    @transaction_header = TransactionHeader.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @transaction_header = TransactionHeader.new(params[:transaction_header])
    params[:transaction_header][:receipt_number] = TransactionHeader.last.nil? ? 1 :  (TransactionHeader.last.id + 1).to_i
    @transaction_header.receipt_number = params[:transaction_header][:receipt_number]
    if @transaction_header.save
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) created a new transaction with ID #{@transaction_header.id}.")
    else
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) had an error when attempting to create a new transaction record.")
      #----------------------------presence - of--------------------
      if(!@transaction_header.errors[:transaction_date].nil? && @transaction_header.errors.on(:transaction_date).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@transaction_header.errors[:bank_account_id].nil? && @transaction_header.errors.on(:bank_account_id).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@transaction_header.errors[:receipt_meta_type_id].nil? && @transaction_header.errors.on(:receipt_meta_type_id).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@transaction_header.errors[:receipt_type_id].nil? && @transaction_header.errors.on(:receipt_type_id).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@transaction_header.errors[:received_via_id].nil? && @transaction_header.errors.on(:received_via_id).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"

      end

    end
  end

  def show_personal_transaction
   
    @current_tab_id = params["current_tab_id"]

    
    if request.post?
      #find the list in top
      @list_header = ListHeader.find(params[:list_header_id])

      # params person_id not blank then pass it to params[:id]
      params[:id] = params[:person_id] unless (params[:person_id].nil? || params[:person_id].empty?)

      c1 = Array.new

      #find all people in the lis
      c1 = @list_header.people_on_list  
      @person = Person.find_by_id(params[:id].to_i)
      unless c1.include?(@person)
        #if list just have 1,2 you type 3, you will get person id is 1.---the first valid people in the list
        @person = @list_header.people_on_list.first 
      else
        #if you type the right id of people which is valid in the list
        @person 
      end

      session[:entity_id] = @person.id
      session[:entity_type] = "Person"
      session[:current_person_id] = @person.id
      session[:current_list_id] = @list_header.id

      @p = Array.new
      @p = @list_header.people_on_list
      @list_headers = @current_user.all_lists
    else
      #request.get
      @list_header = ListHeader.find(session[:current_list_id])
      @p = @list_header.people_on_list
      @list_headers = @current_user.all_lists
      @current_person = Person.find(session[:current_person_id])
      @person = case params[:target]
      when 'First' then @p[0]
      when 'Previous' then @p.at((@p.index(@current_person))-1)
      when 'Next' then @p.index(@current_person) != @p.index(@p.last) ? @p[@p.index(@current_person)+1] : @p.first
      when 'Last' then @p.fetch(-1)
      end
      session[:entity_id] = @person.id
      session[:entity_type] = "Person"
      session[:current_person_id] = @person.id
      session[:current_list_id] = @list_header.id
    end



    respond_to do |format|
      format.js
    end
  end

end
