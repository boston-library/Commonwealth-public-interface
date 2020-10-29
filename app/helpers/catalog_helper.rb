# frozen_string_literal: true

module CatalogHelper
  include Blacklight::CatalogHelperBehavior
  include CommonwealthVlrEngine::CatalogHelperBehavior

  def render_item_breadcrumb(document, link_class = nil)
    if document[:institution_pid_ssi] && document[:collection_pid_ssm]
      inst_link = link_to(document[blacklight_config.institution_field.to_sym].first,
                          institution_path(id: document[:institution_pid_ssi]),
                          class: 'institution_breadcrumb')
      connector = icon('fas', 'arrow-right', aria: { hidden: true })
      inst_link + connector + super
    end
  end
end
