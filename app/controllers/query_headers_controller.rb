class QueryHeadersController < ApplicationController

  def new
    @query_header = QueryHeader.new
    @query_header.name = QueryHeader.random_name
    @query_header.group = "temp"
    @query_header.status = true
    @query_header.save
    @query_criteria = QueryCriteria.new
    @query_seleciton = QuerySelection.new
    @query_sorter = QuerySorter.new
    respond_to do |format|
      format.html
    end
  end


  def update
    @query_header = QueryHeader.find(params[:id].to_i)
    if (!@query_header.query_criterias.empty?)
      if (@query_header.update_attributes(params[:query_header]))
        @query_header.group = "save"
        @query_header.status = true if @query_header.status.nil?
        @query_header.save
        if (params[:new])
          flash.now[:message] = flash_message(:type => "object_created_successfully", :object => "query")
        else        
          flash.now[:message] = flash_message(:type => "object_updated_successfully", :object => "query")
        end
        @query_criteria = QueryCriteria.new
        @query_seleciton = QuerySelection.new
        @query_sorter = QuerySorter.new
      else
        flash.now[:error] = flash_message(:type => "field_missing", :field => "name") if (!@query_header.errors.on(:name).nil? && @query_header.errors.on(:name).include?("can't be blank"))
        flash.now[:error] = flash_message(:type => "uniqueness_error", :field => "name") if (!@query_header.errors.on(:name)..nil? && @query_header.errors.on(:name).include?("has already been taken"))
      end
    else
      flash.now[:error] = flash_message(:message => "No criteria")
    end
    respond_to do |format|
      format.js
    end
  end

  def show_sql_statement
    @query_header = QueryHeader.find(params[:id].to_i)
    respond_to do |format|
      format.js
    end
  end

  def run
    @query_header = QueryHeader.find(params[:id].to_i)
    @people = @query_header.run
    top = params[:top]
    if(top=="number")
      value = params[:top_number].to_i
    else
      value = params[:top_percent].to_i*@people.size/100
    end

    @people = @people[0,value] if (value>0)
    @query_header.result_size = @people.size
    @query_header.save

    #clear query result temp table, and save result to temp table
    QueryResultGrid.find_all_by_login_account_id(session[:user]).each do |i|
      i.destroy
    end

    @query_result_columns = Array.new

    if @query_header.query_selections.empty?
      @query_result_columns << "First Name"
      @query_result_columns << "Family Name"
      @people.each do |person|
        @qrg = QueryResultGrid.new
        @qrg.login_account_id = session[:user]
        @qrg.grid_object_id = person.id
        @qrg.field_1 = person.first_name        
        @qrg.field_2 = person.family_name        
        @qrg.save
      end
    else
      @query_header.query_selections.each do |i|
        @query_result_columns << i.field_name
      end
      @people.each do |person|
        @qrg = QueryResultGrid.new
        @qrg.login_account_id = session[:user]
        @qrg.grid_object_id = person.id
        @query_header.query_selections.each do |i|
          if i.sequence<=10
            if i.table_name == "people"
              if i.data_type == "Integer FK"
                @qrg.__send__("field_#{i.sequence}=".to_sym, person.__send__(i.field_name.to_sym).name) unless person.__send__(i.field_name.to_sym).nil?
              else
                @qrg.__send__("field_#{i.sequence}=".to_sym, person.__send__(i.field_name.to_sym))
              end              
            else
              if i.data_type == "Integer FK"
                @qrg.__send__("field_#{i.sequence}=".to_sym, person.__send__(i.table_name.underscore.to_sym).first.__send__(i.field_name.to_sym).name) unless (person.__send__(i.table_name.underscore.to_sym).empty? && person.__send__(i.table_name.underscore.to_sym).first.__send__(i.field_name.to_sym).nil?)
              else
                @qrg.__send__("field_#{i.sequence}=".to_sym, person.__send__(i.table_name.underscore.to_sym).first.__send__(i.field_name.to_sym)) unless person.__send__(i.table_name.underscore.to_sym).empty?
              end
            end
          end
          @qrg.save
        end
      end
    end
    @list_header = ListHeader.new
    respond_to do |format|
      format.js
    end
  end

  def clear
    @query_header = QueryHeader.find(params[:id].to_i)
    @query_header.query_criterias.each do |c|
      c.destroy
    end
    @query_header.query_criterias.clear

    @query_header.query_selections.each do |s|
      s.destroy
    end
    @query_header.query_selections.clear

    @query_header.query_sorters.each do |s|
      s.destroy
    end
    @query_header.query_sorters.clear
    @query_criteria = QueryCriteria.new
    respond_to do |format|
      format.js
    end
  end

  def edit
    @query_header = QueryHeader.find(params[:id].to_i)
    @query_criteria = QueryCriteria.new
    @query_seleciton = QuerySelection.new
    @query_sorter = QuerySorter.new
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @query_header = QueryHeader.find(params[:id].to_i)
    @query_header.destroy
    respond_to do |format|
      format.js
    end
  end

  def copy
    @query_header = QueryHeader.find(params[:id].to_i)
    respond_to do |format|
      format.js
    end
  end

  def create
    @query_header_old = QueryHeader.find(params[:source_id].to_i)
    @query_header = QueryHeader.new(params[:query_header])
    @query_header.group = "save"
    @query_header.status = true
    if @query_header.save

      @query_header_old.query_criterias.each do |i|
        @query_criteria = QueryCriteria.new(i.attributes)
        @query_criteria.query_header = @query_header
        @query_criteria.save
      end

      @query_header_old.query_selections.each do |i|
        @query_selection = QuerySelection.new(i.attributes)
        @query_selection.query_header = @query_header
        @query_selection.save
      end

      @query_header_old.query_sorters.each do |i|
        @query_sorter = QuerySorter.new(i.attributes)
        @query_sorter.query_header = @query_header
        @query_sorter.save
      end
      flash.now[:message] = flash_message(:type => "object_created_successfully", :object => "query")
    else
      flash.now[:error] = flash_message(:type => "field_missing", :field => "name") if (!@query_header.errors.nil? && @query_header.errors.on(:name).include?("can't be blank"))
      flash.now[:error] = flash_message(:type => "uniqueness_error", :field => "name") if (!@query_header.errors.nil? && @query_header.errors.on(:name).include?("has already been taken"))
    end
    respond_to do |format|
      format.js
    end
  end

  def query_header_to_xml
    @query_header = QueryHeader.find(params[:id])
    respond_to do |format|
      format.xml
    end

  end

  def index
    respond_to do |format|
      format.html
    end
  end

end
