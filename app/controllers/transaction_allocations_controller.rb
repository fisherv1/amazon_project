class TransactionAllocationsController < ApplicationController
  # System Log stuff added

  def new    
    @field = params[:param1]
    if @field == "transaction_allocation"
      @transaction_allocation_grid = TempTransactionAllocationGrid.new
    else
      @transaction_allocation = TransactionAllocation.new
      @transaction_header_id = params[:param2]
    end
  end

  def edit
    @transaction_allocation = TransactionAllocation.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def temp_edit
    @temp_transaction_allocation_grid = TempTransactionAllocationGrid.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @transaction_allocation = TransactionAllocation.new(params[:transaction_allocation])
    @transaction_header_id = params[:transaction_allocation][:transaction_header_id]
    if @transaction_allocation.save
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) created a new transaction allocation with ID #{@transaction_allocation.id}.")
    else
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) had an error when attempting to create a new transaction allocation.")
      #----------------------------presence - of--------------------
      if(!@transaction_allocation.errors[:transaction_header_id].nil? && @transaction_allocation.errors.on(:transaction_header_id).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@transaction_allocation.errors[:receipt_account_id].nil? && @transaction_allocation.errors.on(:receipt_account_id).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@transaction_allocation.errors[:amount].nil? && @transaction_allocation.errors.on(:amount).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data".
          end
  
        @transaction_header = TransactionHeader.find(@transaction_header_id)
        @transaction_allocations = @transaction_header.transaction_allocations
        @transaction_allocation_value = 0
        @transaction_allocations.each do |transaction_transaction|
          @transaction_allocation_value += transaction_transaction.amount.to_f
        end
        @transaction_header.update_attribute(:total_amount,@transaction_allocation_value )
        respond_to do |format|
          format.js
        end
      end
    end
  end
  
  def temp_update
    @temp_transaction_allocation_grid = TempTransactionAllocationGrid.find(params[:id])
    if @temp_transaction_allocation_grid.update_attributes(params[:temp_transaction_allocation_grid])
      #system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) updated the details for Transaction Allocation with ID #{@transaction_allocation.id}.")
    else
      #system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) had an error when attempting to update a transaction allocation record.")
      #----------------------------presence - of------------------
      if(!@temp_transaction_allocation_grid.errors[:field_1].nil? && @temp_transaction_allocation_grid.errors.on(:field_1).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@temp_transaction_allocation_grid.errors[:field_5].nil? && @temp_transaction_allocation_grid.errors.on(:field_5).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      else
        flash.now[:error] = "Exception happen, please try again"
      end
    end

    @temp_allocations = @current_user.all_temp_allocation
    @temp_allocation_value = 0
    @temp_allocations.each do |temp_transaction|
      @temp_allocation_value += temp_transaction.field_5.to_f
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    @transaction_allocation = TransactionAllocation.find(params[:id])
    if @transaction_allocation.update_attributes(params[:transaction_allocation])
      #system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) updated the details for Transaction Allocation with ID #{@transaction_allocation.id}.")
    else
      #system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) had an error when attempting to update a transaction allocation record.")
      #----------------------------presence - of------------------
      if(!@transaction_allocation.errors[:receipt_account_id].nil? && @transaction_allocation.errors.on(:receipt_account_id).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@transaction_allocation.errors[:amount].nil? && @transaction_allocation.errors.on(:amount).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      else
        flash.now[:error] = "Exception happen, please try again"
      end
    end
    @transaction_header_id = @transaction_allocation.transaction_header_id
   
    @transaction_header = @transaction_allocation.transaction_header
    @transaction_allocations = @transaction_header.transaction_allocations
    @transaction_allocation_value = 0
    @transaction_allocations.each do |transaction_transaction|
      @transaction_allocation_value += transaction_transaction.amount.to_f
    end
    @transaction_header.update_attribute(:total_amount,@transaction_allocation_value )
    respond_to do |format|
      format.js
    end
  end

  def temp_create
    @temp_transaction_allocation_grid = TempTransactionAllocationGrid.new(params[:temp_transaction_allocation_grid])
    @temp_transaction_allocation_grid.login_account_id = @current_user
    if @temp_transaction_allocation_grid.save
   
    else
      #----------------------------presence - of--------------------
      if(!@temp_transaction_allocation_grid.errors[:field_1].nil? && @temp_transaction_allocation_grid.errors.on(:field_1).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      elsif(!@temp_transaction_allocation_grid.errors[:field_5].nil? && @temp_transaction_allocation_grid.errors.on(:field_5).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      else
        flash.now[:error] = "Exception happen, please try again"
      end
    end

    @temp_allocations = @current_user.all_temp_allocation
    @temp_allocation_value = 0
    @temp_allocations.each do |temp_transaction|
      @temp_allocation_value += temp_transaction.field_5.to_f
    end
    
    respond_to do |format|
      format.js
    end
  end

  def extention_name_finder


  end


  
end
