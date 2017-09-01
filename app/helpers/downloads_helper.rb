module DownloadsHelper
  include CommonwealthVlrEngine::DownloadsHelperBehavior

  # always return false, because we are seldom 100% sure, caution preferred
  # therefore always show indemnification warning
  def public_domain?(document)
    false
  end

  # methods below not needed, keep for potential future use
=begin
  def has_downloadable_images? document, files_hash
    is_a_bpl_item?(document) && super
  end

  def is_a_bpl_item? document
    document[:institution_name_ssim].include? 'Boston Public Library'
  end
=end

end
