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
      coll_links = []
      0.upto document[:collection_pid_ssm].length-1 do |index|
        coll_links << link_to(document[blacklight_config.collection_field.to_sym][index],
                              collection_path(:id => document[:collection_pid_ssm][index]),
                              :class => 'collection_breadcrumb')
      end
      inst_link + connector + coll_links.join(' / ').html_safe
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

end