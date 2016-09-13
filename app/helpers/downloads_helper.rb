module DownloadsHelper
  include CommonwealthVlrEngine::DownloadsHelperBehavior

  def has_downloadable_images? document, files_hash
    is_a_bpl_item?(document) && super
  end

  def is_a_bpl_item? document
    document[:institution_name_ssim].include? 'Boston Public Library'
  end

end