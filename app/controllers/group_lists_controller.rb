class GroupListsController < ApplicationController
  # System Logging added here

  def show_lists

    @group_type = GroupType.find(params[:group_id])
    #@list_headers = @group_type.list_headers
    @group_list = GroupList.new
    @group_lists = @group_type.group_lists
   
    respond_to do |format|
      format.js
    end
  end


  #*********new design************
  def edit
    #use the id to store the group id passed to this action
    #but :data_id may still put here to ensure that other ajax call use :data_id to pass the id of group.
    id = params[:data_id].nil? ? params[:grid_object_id] : params[:data_id]
    @group = GroupType.find(id)
    @list_headers = @current_user.all_person_lists
    @group_list = GroupList.new
    @group_lists = @group.group_lists

    
    respond_to do |format|
      format.js
    end
  end

  def show_list_des
    @list_header = ListHeader.find(params[:list_id])
    respond_to do |format|
      format.js
    end
  end

  def create

    @group_list = GroupList.new(params[:group_list])
    if @group_list.save
      system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) created a new Group List #{@group_list.id}.")
      flash.now[:message] = flash_message(:type => "object_created_successfully", :object => "Group List")
    else
      flash.now[:error] = flash_message(:type => "field_missing", :field => "tag_id")if (!@group_list.errors[:tag_id].nil? && @group_list.errors.on(:tag_id).include?("can't be blank"))
      flash.now[:error] = flash_message(:type => "field_missing", :field => "list_header_id")if (!@group_list.errors[:list_header_id].nil? && @group_list.errors.on(:list_header_id).include?("can't be blank"))
      flash.now[:error] = flash_message(:type => "uniqueness_error", :field => "list_header_id")if(!@group_list.errors[:list_header_id].nil? && @group_list.errors.on(:list_header_id).include?("has already been taken"))
    end
      @group_types = GroupType.system_user_groups
       @select_group_id = @group_list.group_type.id
    respond_to do |format|
      format.js
    end
  end

  def destroy

    @group_list = GroupList.find(params[:id].to_i)

    @group_list.destroy
      @group_types = GroupType.system_user_groups
      @select_group_id = @group_list.group_type.id
    system_log("Login Account #{@current_user.user_name} (#{@current_user.id}) deleted Group List #{@group_list.id}.")
    respond_to do |format|
      format.js
    end
  end


end
