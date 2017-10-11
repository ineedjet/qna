require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :gon_user

  check_authorization unless: :devise_controller?


  private

  def gon_user
    gon.current_user = current_user if current_user
  end
end
