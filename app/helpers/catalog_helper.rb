module CatalogHelper
  include Blacklight::CatalogHelperBehavior
  include CommonwealthVlrEngine::CatalogHelper

  def render_item_breadcrumb(document)
    if document[:institution_pid_ssi] && document[:collection_pid_ssm]
      inst_link = link_to(document[blacklight_config.institution_field.to_sym].first,
                          institution_path(:id => document[:institution_pid_ssi]),
                          :class => 'institution_breadcrumb')
      connector = content_tag(:span, '',
                              :class => 'glyphicon glyphicon-arrow-right item-breadcrumb-separator')
      inst_link + connector + setup_collection_links(document, 'collection_breadcrumb').join(' / ').html_safe
    end
  end

  # return the correct name of the institution to link to for OAI objects
  def return_oai_inst_name(document)
    inst_name = nil
    if document[:note_tsim]
      inst_name = 'NOBLE Digital Heritage' if document[:note_tsim].join(' ').match(/NOBLE/)
    end
    inst_name.presence || document[blacklight_config.institution_field.to_sym].first || t('blacklight.oai_objects.default_inst_name')
  end

end