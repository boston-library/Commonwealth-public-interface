module InstitutionsHelper
  include CommonwealthVlrEngine::InstitutionsHelperBehavior

  # whether the A-Z link menu should be displayed in institutions#index
  def should_render_inst_az?
    true
  end
end
