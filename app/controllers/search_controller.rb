class SearchController < ApplicationController
  authorize_resource

  def search
    render 'search'
  end
end
