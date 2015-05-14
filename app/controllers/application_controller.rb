class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller  
# Adds Hydra behaviors into the application controller 
  include Hydra::Controller::ControllerBehavior

  # Please be sure to implement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions. 

  layout 'blacklight'

  protect_from_forgery

  after_filter :store_location

  # redirect after login to previous non-login page
  # TODO figure out why it doesn't work for Polaris or Facebook logins
  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.fullpath.match(/\/users\/auth\//) &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def create_img_sequence(image_files, current_img_pid)
    page_sequence = {}
    page_sequence[:current] = current_img_pid
    page_sequence[:index] = image_files.index(current_img_pid) + 1
    page_sequence[:total] = image_files.length
    page_sequence[:prev] = page_sequence[:index]-2 > -1 ? image_files[page_sequence[:index]-2] : nil
    page_sequence[:next] = image_files[page_sequence[:index]].presence
    page_sequence
  end
  helper_method :create_img_sequence

end
