# frozen_string_literal: true

module DownloadsHelper
  include CommonwealthVlrEngine::DownloadsHelperBehavior

  # return false, unless we 100% assert no copyright
  def public_domain?(document)
    return true if document[:rightsstatement_ss] == 'No Copyright - United States'

    false
  end

  # methods below not needed, keep for potential future use
  # def has_downloadable_images? document, files_hash
  #   is_a_bpl_item?(document) && super
  # end

  # def is_a_bpl_item? document
  #   document[:institution_name_ssim].include? 'Boston Public Library'
  # end
end
