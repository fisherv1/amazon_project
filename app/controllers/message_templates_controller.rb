class MessageTemplatesController < ApplicationController

  def new
    @mail_template = params[:param1] == "person" ? PersonMailTemplate.new : OrganisationMailTemplate.new
    @type = params[:param1]   
    @table_attributes = TableMetaMetaType.table_categroy(@type)
    @prefix_table_value = (params[:param1]== "person")? "@people." : "@organisations."
    respond_to do |format|
      format.js
    end
    
  end

  def create
    @mail_template = (params[:type]+"_mail_template").camelize.constantize.new(params[:mail_template])
    @type = params[:type]
    @model_type = (params[:type]+"_mail_template").camelize
    if @mail_template.save
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) created a new mail template with ID #{@mail_template.id}.")
    else
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) had an error when attempting to create a new mail template.")
      #----------------------------presence - of--------------------
      if(!@mail_template.errors[:name].nil? && @mail_template.errors.on(:name).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      else
        flash.now[:error] = "A record with same name already exists, please try other name"
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def edit
    @mail_template = MessageTemplate.find(params[:id])
    #@table_attributes = @mail_template.class.to_s == "PersonMailTemplate" ? TableMetaMetaType.table_categroy("person") : TableMetaMetaType.table_categroy("organisation")
    @type = params[:params2]
    @table_attributes = TableMetaMetaType.table_categroy(@type)
    @prefix_table_value = (params[:params2]== "person")? "@people." : "@organisations."

    respond_to do |format|
      format.js
    end
  end

  def update
    @mail_template = MessageTemplate.find(params[:id])
    if @mail_template.update_attributes(params[:mail_template])
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) updated the details for Mail Template with ID #{@mail_template.id}.")
    else
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) had an error when attempting to update a Mail Template record.")
      #----------------------------presence - of------------------
      if(!@mail_template.errors[:name].nil? && @mail_template.errors.on(:name).include?("can't be blank"))
        flash.now[:error] = "Please Enter All Required Data"
      else
        flash.now[:error] = "A record with same name already exists, please try other name"
      end

    end
    @type = params[:type]
    @model_type = (params[:type]+"_mail_template").camelize

    respond_to do |format|
      format.js
    end
    

  end



  def page_initial
    @render_page = params[:render_page]
    @field = params[:field]
    @type = params[:type]
    @model_type = (params[:type]+"_mail_template").camelize
    @entity_list_headers = (params[:type]== "person")? @current_user.all_person_lists : @current_user.all_organisation_lists
    @entity_query_headers = QueryHeader.saved_query_header
    @mail_templates = (params[:type]== "person")? PersonMailTemplate.active_record : OrganisationMailTemplate.active_record
    @entity_type = (params[:type]== "person")? "person" : "organisation"
    
   
    respond_to do |format|
      format.js
    end
  end

  def drop_down_list
    @tag_types = TableMetaType.mmt_name_finder(params[:level1_value])
    @drop_down_field = params[:drop_down_field]
    respond_to do |format|
      format.js
    end

  end

  def drop_down_list_level2_3
    @tag = TableMetaType.name_finder(params[:level2_value])
    @tag_category = @tag.category
    @drop_down_field = params[:drop_down_field]
    respond_to do |format|
      format.js
    end

  end

  def retrieve_mail_template
    @mail_template = MessageTemplate.find(params[:id])
    @mail_template.to_be_removed = false
    @mail_template.save!
    @type = (@mail_template.class.to_s == "PersonMailTemplate")? "person" : "organisation"
    @model_type = (@type+"_mail_template").camelize
    system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) retrieve Mail Template ID #{@mail_template.id}.")
    respond_to do |format|
      format.js
    end


  end

  def destroy_mail_template
    @mail_template = MessageTemplate.find(params[:id])
    @mail_template.to_be_removed = true
    @mail_template.save!
    @type = (@mail_template.class.to_s == "PersonMailTemplate")? "person" : "organisation"
    @model_type = (@type+"_mail_template").camelize
    system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) deleted Mail Template ID #{@mail_template.id}.")
    respond_to do |format|
      format.js
    end
  end

  def create_mail
    @list_header = ListHeader.find(params[:list_header_id])
    @mail_template = MessageTemplate.find(params[:message_template_id])
   
    @mail_merge = @mail_template.body
    @mail_merge = @mail_merge.gsub(/&lt;/, "<")
    @mail_merge = @mail_merge.gsub(/&gt;/, ">")
    file_name = "message_templates/temp/"+@current_user.user_name
    #file_name = @current_user.user_name
    file_dir = "#{RAILS_ROOT}/app/views/#{file_name}/"
    FileUtils.mkdir_p("#{file_dir}")
    File.open("#{file_dir}"+"_create_mail_template.html.erb", 'w') do |f2|
      f2.puts "#{@mail_merge}"
    end

    @list_header_id = params[:list_header_id]
    @message_template_id = params[:message_template_id]
    @entity_type = params[:entity_type]
    redirect_to :action => "merge_mail", :list_header_id => params[:list_header_id], :message_template_id => params[:message_template_id], :entity_type => params[:entity_type]
  end

  def merge_mail

    #----prepare the data which pdf use
    @list_header = ListHeader.find(params[:list_header_id])
    @mail_template = MessageTemplate.find(params[:message_template_id])
    @content = @mail_template.body
    @content = @content.gsub(/&lt;/, "<")
    @content = @content.gsub(/&gt;/, ">")
    @entity_type = params[:entity_type]
    @entities = @list_header.entity_on_list #people
    template_name = @mail_template.name
    time_stamp = Time.now.strftime("%d-%m-%y-%I:%M%p")

    #---------render the html which have another html which use the object above and create temp dir

    # "#{RAILS_ROOT}/"
    file_name = "temp/"+@current_user.user_name+"/merge_docs"
    file_dir = "public/#{file_name}"
    #@render_url = "message_templates/temp/"+@current_user.user_name+"/create_mail_template.html.erb"
    @render_url = "message_templates/create_mail_template.html.erb"
    @pdf = ""
    @pdf << render_to_string(:partial => "message_templates/render_mail_template")

    FileUtils.mkdir_p(file_dir)
    File.open("#{file_dir}/#{template_name}#{time_stamp}.html", 'w') do |f2|
      f2.puts  "#{@pdf}"
    end


    #-----change html to pdf and give the flashmessage for click

    system "wkhtmltopdf #{file_dir}/#{template_name}#{time_stamp}.html #{file_dir}/#{template_name}#{time_stamp}.pdf; rm #{file_dir}/*.html"
    flash.now[:message] = "Sucessfully added-<a href='/#{file_name}/#{template_name}#{time_stamp}.pdf' style='color:red;'>#{template_name}#{time_stamp}.pdf</a>"
    #for create record in the database mail-logs
    @entities.each do |entity|
      @mail_log = entity.mail_logs.new
      @mail_log.doc_id = @mail_template.id
      @mail_log.channel = "mail"
      @mail_log.save

    end
    respond_to do |format|
      format.js
    end
  end


  def person_mail_log_filter

    conditions = Array.new
    person_id = params[:mail_log_filter][:person_id]
    start_date = params[:mail_log_filter][:start_date].to_date.yesterday.to_s
    end_date = params[:mail_log_filter][:end_date].to_date.tomorrow.to_s
    creator_username = params[:mail_log_filter][:creator_username]
    @date_valid = true

    unless (person_id.blank?)
      conditions << ("entity_id=" + person_id)
    end

    if valid_date(start_date) && valid_date(end_date)
      unless start_date.blank? || end_date.blank?
        start_date = "#{Date.today().last_year.yesterday.to_s}" if start_date.blank?
        end_date = "#{Date.today().tomorrow.to_s}" if end_date.blank?
        conditions << ("start_date=" + start_date)
        conditions << ("end_date=" + end_date)
      end
      @date_valid = true
    else
      @date_valid = false
      flash.now[:error] = "Please make sure the start date and end date are entered in valid format (dd-mm-yyyy)"
    end

    unless (creator_username.blank?)
      creator_id = LoginAccount.find_by_user_name("#{creator_username}").id.to_s rescue creator_id = "0"      
      conditions << ("creator_id="+ creator_id)
    end

    @query = conditions.join('&')

    respond_to do |format|
      format.js
    end
    
  end

  def organisation_mail_log_filter
    conditions = Array.new
    organisation_id = params[:organisation_id]
    start_date = params[:start_date].to_date.yesterday.to_s
    end_date = params[:end_date].to_date.tomorrow.to_s
    creator_username = params[:creator_username]
    @date_valid = true

    unless (organisation_id.blank?)
      conditions << ("entity_id=" + organisation_id)
    end

    if valid_date(start_date) && valid_date(end_date)
      unless start_date.blank? || end_date.blank?
        start_date = "#{Date.today().last_year.yesterday.to_s}" if start_date.blank?
        end_date = "#{Date.today().tomorrow.to_s}" if end_date.blank?
        conditions << ("start_date=" + start_date)
        conditions << ("end_date=" + end_date)
      end
      @date_valid = true
    else
      @date_valid = false
      flash.now[:error] = "Please make sure the start date and end date are entered in valid format (dd-mm-yyyy)"
    end

    unless (creator_username.blank?)
      creator_id = LoginAccount.find_by_user_name("#{creator_username}").id.to_s rescue creator_id = "0"
      conditions << ("creator_id="+ creator_id)
    end

    @query = conditions.join('&')

    respond_to do |format|
      format.js
    end

  end




end
