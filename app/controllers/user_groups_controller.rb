class UserGroupsController < ApplicationController


  def add_security

    unless params[:add_group_id].nil?
      params[:add_group_id].each do |group_id|
        @user_group = UserGroup.new
        @user_group.user_id = params[:user_id]
        @user_group.group_id = group_id

        @user_group.save!


      end
    end
    @login_account = LoginAccount.find(params[:user_id])
    puts"dubg111---#{@login_account.to_yaml}"
    @groups = @login_account.groups
    puts"debug222===#{@groups.to_yaml}"
    respond_to do |format|

      format.js


    end
  end
  
  def remove_security
    
    
  end

  def show_groups
    @group_meta_meta_types = GroupMetaMetaType.find_by_name("Security",:order => "name")rescue  @group_meta_meta_types =  GroupMetaMetaType.new
    #puts"DEBUG11111---#{@group_meta_meta_types.to_yaml}"
    @group_meta_types = GroupMetaType.find(:first, :conditions => ["tag_meta_type_id=? AND name=?", @group_meta_meta_types.id, "System Users"])rescue  @group_meta_types =  GroupMetaType.new
    gp_id = @group_meta_types.id
    #puts"DEBUG222222---#{@group_meta_types.to_yaml}"
    @group_types = GroupType.find(:all, :conditions => ["tag_type_id=?", gp_id])rescue  @group_types =  GroupType.new
    #puts"DEBUG333333333---#{@groups.to_yaml}"
    respond_to do |format|
      format.js
    end

  end
end
