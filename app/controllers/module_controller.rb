class ModuleController < ApplicationController
  # Sytem Logging added

  # When the user selects a module from the menu, we need to:
  # 1 - Set the session[:module] to reflect the module they are in
  # 2 - Redirect them to the appropriate landing page for that module

  def core
    session[:module] = "core"
    redirect_to :controller => "people", :action => "show"
  end

  def receipting
    session[:module] = "receipting"
    redirect_to :controller => "receipting", :action => "personal_deposit"
  end

  def membership
    session[:module] = "membership"
    redirect_to :controller => "membership", :action => "step_1"
  end

  def become_membership
    session[:module] = "membership"

    redirect_to :controller => "membership", :action => "step_1",:id=>params[:id]
  end

   def manage_membership
    session[:module] = "membership"
    membership = Membership.find_by_person_id(params[:id])
    action = case membership.membership_status.name
    when "Prospective" then "step_2"
    when "In-review" then "step_2"
    end
    redirect_to :controller => "membership", :action => action, :id => membership.id
   end


  def fundraising
    session[:module] = "core"
    redirect_to :controller => "people", :action => "show"
  end

  def case_management
    session[:module] = "core"
    redirect_to :controller => "people", :action => "show"
  end

  def administration
    session[:module] = "administration"
    redirect_to :controller => "client_setups", :action => "parameters"
  end

  def dashboard
    session[:module] = "dashboard"
    redirect_to :controller => "dashboards", :action => "index"
  end

  def client_setup
    session[:module] = "client_setup"
    redirect_to :controller => "client_setups", :action => "client_organisation"
  end
  
end
