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
      coll_link = link_to(document[blacklight_config.collection_field.to_sym].first,
                          collection_path(:id => document[:collection_pid_ssm].first),
                          :class => 'collection_breadcrumb')
      inst_link + connector + coll_link
    end
  end

  # return the correct name of the institution to link to for OAI objects
  def return_oai_inst_name(document)
    inst_name = nil
    if document[:note_tsim]
      inst_name = 'NOBLE Digital Heritage' if document[:note_tsim].join(' ').match(/NOBLE/)
    end
    inst_name.presence || document[blacklight_config.institution_field.to_sym].first
  end

  def should_render_col_az?
    true
  end

end