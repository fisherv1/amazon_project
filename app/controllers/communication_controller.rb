class CommunicationController < ApplicationController


  def email
    @list_headers = @current_user.all_lists
    @message_templates = MessageTemplate.find(:all)
    @message_template = MessageTemplate.new
  end


  def create_message_template
    @message_template = MessageTemplate.new(params[:message_template])

    if @message_template.save
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) created a new message template with ID #{@message_template.id}.")
      flash[:message] = flash_message(:type => "object_created_successfully", :object => "message template")
    else
      flash[:error] = flash_message(:message => "A Template Already Exists With That Name")
    end
    respond_to do |format|
      format.js
    end    
  end

  def refresh_template_message_select
    @list_headers = @current_user.all_lists
    @message_templates = MessageTemplate.find(:all)
    respond_to do |format|
      format.js
    end
  end

  def new_message_template
    @message_template = MessageTemplate.new
    respond_to do |format|
      format.js
    end
  end

  def edit_message_template
    @message_template = MessageTemplate.find(params[:id])
    respond_to do |format|
      format.js
    end
  end


  def update_message_template
    @message_template = MessageTemplate.find_by_id(params[:id])
    if @message_template.update_attributes(params[:message_template])
      flash[:message] = flash_message(:type => "object_updated_successfully", :object => "message template")
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) updated Message Tempalte with ID #{@message_template.id}.")
    else
      flash[:error] = flash_message(:message => "A Template Already Exists With That Name")
    end
    respond_to do |format|
      format.js
    end
  end

  def send_email
    subject = params[:email][:subject]
    message_template_id = params[:message_template_id]
    list_header_id = params[:list_header_id]

    render :nothing => true

  end


end
