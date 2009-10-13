class GridsController < ApplicationController

  def people_search_grid
    page = (params[:page]).to_i
    rp = (params[:rp]).to_i
    query = params[:query]
    qtype = params[:qtype]
    sortname = params[:sortname]
    sortorder = params[:sortorder]

    if (!sortname)
      sortname = "grid_object_id"
    end

    if (!sortorder)
      sortorder = "asc"
    end

    if (!page)
      page = 1
    end

    if (!rp)
      rp = 10
    end

    start = ((page-1) * rp).to_i
    query = "%"+query+"%"

    # No search terms provided
    if(query == "%%")
      @people = PeopleSearchGrid.find(:all,
    :conditions => ["login_account_id = ?", session[:user]],
  	:order => sortname+' '+sortorder,
  	:limit =>rp,
  	:offset =>start
  	)
      count = PeopleSearchGrid.count(:all, :conditions => ["login_account_id = ?", session[:user]])
    end

    # User provided search terms
    if(query != "%%")
        @people = PeopleSearchGrid.find(:all,
	  :order => sortname+' '+sortorder,
	  :limit =>rp,
  	  :offset =>start,
  	  :conditions=>[qtype +" like ? AND login_account_id = ?", query, session[:user]])
	count = PeopleSearchGrid.count(:all,
	  :conditions=>[qtype +" like ? AND login_account_id = ?", query, session[:user]])
    end

    # Construct a hash from the ActiveRecord result
    return_data = Hash.new()
    return_data[:page] = page
    return_data[:total] = count

    return_data[:rows] = @people.collect{|u| {:id => u.grid_object_id,
  			   :cell=>[u.grid_object_id,
  			   u.field_1,
  			   u.field_2,
           u.field_3,
           u.field_4,
           u.field_5]}}

    # Convert the hash to a json object
    render :text=>return_data.to_json, :layout=>false
  end

  def query_result_grid
    page = (params[:page]).to_i
    rp = (params[:rp]).to_i
    query = params[:query]
    qtype = params[:qtype]
    sortname = params[:sortname]
    sortorder = params[:sortorder]

    if (!sortname)
      sortname = "grid_object_id"
    end

    if (!sortorder)
      sortorder = "asc"
    end

    if (!page)
      page = 1
    end

    if (!rp)
      rp = 10
    end

    start = ((page-1) * rp).to_i
    query = "%"+query+"%"

    # No search terms provided
    if(query == "%%")
      @people = QueryResultGrid.find(:all,
    :conditions => ["login_account_id = ?", session[:user]],
  	:order => sortname+' '+sortorder,
  	:limit =>rp,
  	:offset =>start
  	)
      count = QueryResultGrid.count(:all, :conditions => ["login_account_id = ?", session[:user]])
    end

    # User provided search terms
    if(query != "%%")
        @people = QueryResultGrid.find(:all,
	  :order => sortname+' '+sortorder,
	  :limit =>rp,
  	  :offset =>start,
  	  :conditions=>[qtype +" like ? AND login_account_id = ?", query, session[:user]])
	count = QueryResultGrid.count(:all,
	  :conditions=>[qtype +" like ? AND login_account_id = ?", query, session[:user]])
    end

    # Construct a hash from the ActiveRecord result
    return_data = Hash.new()
    return_data[:page] = page
    return_data[:total] = count

    return_data[:rows] = @people.collect{|u| {:id => u.grid_object_id,
  			   :cell=>[u.grid_object_id,
  			   u.field_1,
  			   u.field_2,
           u.field_3,
           u.field_4,
           u.field_5]}}

    # Convert the hash to a json object
    render :text=>return_data.to_json, :layout=>false
  end

end