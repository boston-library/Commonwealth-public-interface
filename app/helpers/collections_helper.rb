module CollectionsHelper
  include CommonwealthVlrEngine::CollectionsHelperBehavior

  # whether the A-Z link menu should be displayed in collections#index
  def should_render_col_az?
    true
  end

end