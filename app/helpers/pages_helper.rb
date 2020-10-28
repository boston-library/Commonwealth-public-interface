module PagesHelper
  include CommonwealthVlrEngine::PagesHelperBehavior

  def render_about_site_path
    about_dc_path
  end
end
