# frozen_string_literal: true

module CatalogHelper
  include Blacklight::CatalogHelperBehavior
  include CommonwealthVlrEngine::CatalogHelperBehavior

  def render_item_breadcrumb(document, link_class = nil)
    return unless document[:institution_ark_id_ssi] && document[:collection_ark_id_ssim]

    inst_link = link_to(document[blacklight_config.institution_field.to_sym],
                        institution_path(id: document[:institution_ark_id_ssi]),
                        class: 'institution_breadcrumb')
    connector = icon('fas', 'arrow-right', aria: { hidden: true })
    inst_link + connector + super
  end
end
