module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # old Hydra method not included in 5.0.0
  def document_partial_name(document)
    display_type = document[blacklight_config.show.display_type]

    return 'default' unless display_type

    display_type.first.gsub(/^[^\/]+\/[^:]+:/,"").underscore.pluralize
  end


end