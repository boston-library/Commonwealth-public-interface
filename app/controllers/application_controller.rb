# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # adds some site-wide behavior into the application controller
  include CommonwealthVlrEngine::Controller

  layout :determine_layout if respond_to? :layout
end
