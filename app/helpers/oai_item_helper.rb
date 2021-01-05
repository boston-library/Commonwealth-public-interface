# frozen_string_literal: true

module OaiItemHelper
  include CommonwealthVlrEngine::OaiItemHelperBehavior

  # return the correct name of the institution to link to for OAI objects
  def oai_inst_name(document)
    return super unless document[:note_tsim] && document[:note_tsim].join(' ').match(/NOBLE/)

    'NOBLE Digital Heritage'
  end
end
