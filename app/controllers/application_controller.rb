# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # adds some site-wide behavior into the application controller
  include CommonwealthVlrEngine::Controller

  include Bpluser::Controller

  layout :determine_layout if respond_to? :layout

  # TEMPFIX for InvalidAuthenticityToken errors caused by December '25 migration of session_store config
  # (see: c836da9bd919d4b8f94638000c36c075f35c0a6a)
  # @TODO: remove once rescue message is no longer appearing in the logs
  rescue_from ActionController::InvalidAuthenticityToken, with: :rescue_authtoken_error

  def rescue_authtoken_error
    Rails.logger.error "RESCUING SESSION ERROR from #{controller_name}##{action_name}"
    raise ActionController::InvalidAuthenticityToken unless controller_name == 'catalog' && action_name == 'track'

    reset_session
    redirect_to solr_document_path(params[:id]) # can't redirect to catalog#track, only POST allowed

  end
end
