class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :gon_user

  private

  def gon_user
    gon.current_user = current_user if current_user
  end
end
