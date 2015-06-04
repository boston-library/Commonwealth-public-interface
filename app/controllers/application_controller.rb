class ApplicationController < ActionController::Base

  # Adds a few additional behaviors into the application controller
   include Blacklight::Controller

   # adds some site-wide behavior into the application controller
   include CommonwealthVlrEngine::Controller

  # Please be sure to implement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions. 

  layout 'commonwealth-vlr-engine'

  protect_from_forgery

end
