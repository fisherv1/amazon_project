class AdministrationsController < ApplicationController

  before_filter :check_authentication

  def index
    @role = Role.new
    @role_condition = RoleCondition.new
    @role_type = RoleType.new
    respond_to do |format|
      format.html
    end
  end
end