class SearchController < ApplicationController
  skip_authorization_check

  def search
    render 'search'
  end
end
