class QueryDetailsController < ApplicationController

  before_filter :check_authentication

  def new
    @query_detail = QueryDetail.new
    respond_to do |format|
      format.js
    end
  end

  def edit

    respond_to do |format|
      format.js
    end
  end

  def create

    respond_to do |format|
      format.js
    end
  end

  def update

    respond_to do |format|
      format.js
    end
  end


end